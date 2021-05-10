//
//  Utility.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import UIKit
import Locksmith

class Utility: NSObject {
    static let sharedInstance = Utility()
    
    class func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
    
    class func showAlertWindow(title: String, message: String, amtButtons: AlertButtons) {
        DispatchQueue.main.async(execute: {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1;
            alertWindow.makeKeyAndVisible()
        
            let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            switch amtButtons {
            case .None:
                break
            case .Single:
                let defaultAction2 = UIAlertAction(title: "Done", style: .default, handler: { action in
                })
                alert2.addAction(defaultAction2)
                break
            default:
                break
            }
        
            alertWindow.makeKeyAndVisible()
        
            alertWindow.rootViewController?.present(alert2, animated: true, completion: nil)
        })
    }
    
    static func setDefaultValue(_ value: Any ,forKey: String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: forKey)
        defaults.synchronize()
    }
    
    static var appName: String {
        return (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!
    }
    
    static var sessionToken: String {
        return retrieveDataInKeychain(key: UserDefaultValues.Tokens.requestToken)
    }
    
    static var sessionId : String {
        if let id = UserDefaults.standard.string(forKey:UserDefaultValues.Tokens.sessionId){
            return id
        }
        return ""
    }
    
    // MARK: - saveDataInKeychain Operation
    /**
     Llama esta funcion para guardar valores en el Keychain.
     */
    class func saveDataInKeychain(key:String,value:Any) {
        do {
            try Locksmith.saveData(data: [key:value], forUserAccount: appName)
        } catch let myError {
            print(myError)
        }
    }
    
    // MARK: - retrieveDataInKeychain Operation
    /**
     Llama esta funcion para acceder valores guardados en el Keychain.
     */
    class func retrieveDataInKeychain(key:String) -> String {
        let data = Locksmith.loadDataForUserAccount(userAccount: appName)
        if let storeData = data {
            return storeData[key] as! String
        }
        return ""
    }
    
    // MARK: - removeDataInKeychain Operation
    /**
     Llama esta funcion para acceder valores guardados en el Keychain.
     */
    class func removeDataInKeychain(key:String) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: appName)
        } catch let myError {
            print(myError)
        }
    }
    
    
}
