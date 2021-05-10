//
//  NetworkImages.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 6/2/21.
//

import Foundation
import UIKit

var asyncImagesCashArray = NSCache<NSString, UIImage>()

class AsyncImage: UIImageView {
    
    //MARK: - Variables
    private var currentURL: NSString?
    
    //MARK: - Public Methods
    
    func loadAsyncFrom(url: String, placeholder: UIImage?, onCompletion:@escaping (_ image: UIImage)->(),onError:@escaping ()->()) {
        self.image = nil
        
        let imageURL = url as NSString
        if let cashedImage = asyncImagesCashArray.object(forKey: imageURL) {
            image = cashedImage
            onCompletion(cashedImage)
            return
        }
        
        image = placeholder
        
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { image = placeholder; return }
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil {
                    if let imageData = data {
                        if self?.currentURL == imageURL {
                            if let imageToPresent = UIImage(data: imageData) {
                                
                                asyncImagesCashArray.setObject(imageToPresent, forKey: imageURL)
                                self?.image = imageToPresent
                                onCompletion(imageToPresent)
                            } else {
                                
                                self?.image = placeholder
                                onError()
                            }
                        }
                    } else {
                        
                        self?.image = placeholder
                        onError()
                    }
                } else {
                    
                    self?.image = placeholder
                    onError()
                }
            }
            }.resume()
    }
}
