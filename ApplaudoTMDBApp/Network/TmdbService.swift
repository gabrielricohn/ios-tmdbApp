//
//  TmdbService.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 5/2/21.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import SwiftyJSON

class TmdbService {
    
    let rxGetTvShowsCategoryResponse = PublishSubject<ApiResponse>()
    
    let disposeBag = DisposeBag()
    
    var tvCategorySelected : String = ""
    
    let tmdbKey = "e3c9e394cb18a920aa241ff2f5d84bd8"
    
    
    func getTvShowsCategoryApi(tvCategory: TvCategory) {
        
        switch tvCategory {
        case .Popular:
            tvCategorySelected = "popular"
        case .TopRated:
            tvCategorySelected = "top_rated"
        case .OnTv:
            tvCategorySelected = "on_the_air"
        case .AiringToday:
            tvCategorySelected = "airing_today"
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/tv/\(tvCategorySelected)"
        
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        let languageQueryItem = URLQueryItem(name: "language", value: "en-US")
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        components.queryItems = [apiKeyQueryItem, languageQueryItem, pageQueryItem]
        
        let url = components.url?.absoluteString
        
        print(url)
        
        RxAlamofire
            .requestJSON(.get,
                                url!,
                                parameters: nil,
                                encoding: JSONEncoding.default,
                                headers: nil)
            //.debug()
            .subscribe(onNext: { (headerResponse, json) in
            let jsonData = JSON(json)
            let statusCode:Int = headerResponse.statusCode
            if let dict = jsonData.dictionaryObject {
                let code = HTTPResponseCode(rawValue:statusCode) ?? .Unknown
                let apiResponse = NetworkHelper.checkResponse(statusCode: code, responseDict: dict)
                self.rxGetTvShowsCategoryResponse.onNext(apiResponse)
            }
                
        }, onError: {  (error) in
            print("API Response \(url)\nError:\(error.localizedDescription)")
            self.rxGetTvShowsCategoryResponse.onError(error)
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
}
