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
    let rxGetTvDescriptionResponse = PublishSubject<ApiResponse>()
    let rxGetTvCastResponse = PublishSubject<ApiResponse>()
    let rxGetProfileResponse = PublishSubject<ApiResponse>()
    let rxSignInResponse = PublishSubject<ApiResponse>()
    let rxGetAuthTokenResponse = PublishSubject<ApiResponse>()
    let rxSignoutResponse = PublishSubject<ApiResponse>()
    let rxCreateSessionIdResponse = PublishSubject<ApiResponse>()
    let rxSetFavoriteMediaResponse = PublishSubject<ApiResponse>()
    let rxGetFavoriteMediaListResponse = PublishSubject<ApiResponse>()
    
    let disposeBag = DisposeBag()
    
    var tvCategorySelected : String = ""
    
    let tmdbKey = "e3c9e394cb18a920aa241ff2f5d84bd8"
    
    
    func getTvShowsCategoryApi(tvCategory: TvCategory, showId: String) {
        
        switch tvCategory {
        case .Popular:
            tvCategorySelected = "popular"
        case .TopRated:
            tvCategorySelected = "top_rated"
        case .OnTv:
            tvCategorySelected = "on_the_air"
        case .AiringToday:
            tvCategorySelected = "airing_today"
        case .ShowDetails:
            tvCategorySelected = showId
        case .CastAndCrew:
            tvCategorySelected = "\(showId)/credits"
        case .Profile:
            tvCategorySelected = "account"
        case .AuthToken:
            tvCategorySelected = "authentication/token/new"
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        if tvCategory == .Profile || tvCategory == .AuthToken {
            components.path = "/3/\(tvCategorySelected)"
        } else {
            components.path = "/3/tv/\(tvCategorySelected)"
        }
        
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        let languageQueryItem = URLQueryItem(name: "language", value: "en-US")
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        let sessionId = URLQueryItem(name: "session_id", value: Utility.sessionId)
        
        if tvCategory == .CastAndCrew {
            components.queryItems = [apiKeyQueryItem, languageQueryItem]
        } else if tvCategory == .AuthToken {
            components.queryItems = [apiKeyQueryItem]
        } else if tvCategory == .Profile {
            components.queryItems = [apiKeyQueryItem, sessionId]
        } else {
            components.queryItems = [apiKeyQueryItem, languageQueryItem, pageQueryItem]
        }
        
        let url = components.url?.absoluteString
        
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
                
                switch tvCategory {
                case .Popular:
                    self.rxGetTvShowsCategoryResponse.onNext(apiResponse)
                case .TopRated:
                    self.rxGetTvShowsCategoryResponse.onNext(apiResponse)
                case .OnTv:
                    self.rxGetTvShowsCategoryResponse.onNext(apiResponse)
                case .AiringToday:
                    self.rxGetTvShowsCategoryResponse.onNext(apiResponse)
                case .ShowDetails:
                    self.rxGetTvDescriptionResponse.onNext(apiResponse)
                case .CastAndCrew:
                    self.rxGetTvCastResponse.onNext(apiResponse)
                case .Profile:
                    self.rxGetProfileResponse.onNext(apiResponse)
                case .AuthToken:
                    self.rxGetAuthTokenResponse.onNext(apiResponse)
                }
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
                switch tvCategory {
                case .Popular:
                    self.rxGetTvShowsCategoryResponse.onError(error)
                case .TopRated:
                    self.rxGetTvShowsCategoryResponse.onError(error)
                case .OnTv:
                    self.rxGetTvShowsCategoryResponse.onError(error)
                case .AiringToday:
                    self.rxGetTvShowsCategoryResponse.onError(error)
                case .ShowDetails:
                    self.rxGetTvDescriptionResponse.onError(error)
                case .CastAndCrew:
                    self.rxGetTvCastResponse.onError(error)
                case .Profile:
                    self.rxGetProfileResponse.onError(error)
                case .AuthToken:
                    self.rxGetAuthTokenResponse.onError(error)
                }
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
    
    func createSession() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/authentication/session/new"
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        components.queryItems = [apiKeyQueryItem]
        
        
        let url = components.url?.absoluteString
        
        let params: [String: Any] = ["request_token"  : Utility.sessionToken]
        RxAlamofire
            .requestJSON(.post,
                                url!,
                                parameters: params,
                                encoding: JSONEncoding.default,
                                headers: nil)
            //.debug()
            .subscribe(onNext: { (headerResponse, json) in
            let jsonData = JSON(json)
                
            let statusCode:Int = headerResponse.statusCode
            if let dict = jsonData.dictionaryObject {
                let code = HTTPResponseCode(rawValue:statusCode) ?? .Unknown
                let apiResponse = NetworkHelper.checkResponse(statusCode: code, responseDict: dict)
                self.rxCreateSessionIdResponse.onNext(apiResponse)
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
            self.rxCreateSessionIdResponse.onError(error)
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
    
    func signInApi(signInParams: SignInDetails) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/authentication/token/validate_with_login"
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        components.queryItems = [apiKeyQueryItem]
        
        
        let url = components.url?.absoluteString
        
        let params: [String: Any] = ["username" : signInParams.userName,
                                     "password"  : signInParams.password,
                                     "request_token"  : Utility.sessionToken]
        RxAlamofire
            .requestJSON(.post,
                                url!,
                                parameters: params,
                                encoding: JSONEncoding.default,
                                headers: nil)
            //.debug()
            .subscribe(onNext: { (headerResponse, json) in
            let jsonData = JSON(json)
                
            let statusCode:Int = headerResponse.statusCode
            if let dict = jsonData.dictionaryObject {
                let code = HTTPResponseCode(rawValue:statusCode) ?? .Unknown
                let apiResponse = NetworkHelper.checkResponse(statusCode: code, responseDict: dict)
                self.rxSignInResponse.onNext(apiResponse)
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
            self.rxSignInResponse.onError(error)
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
    
    func logoutAPI() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/authentication/session"
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        components.queryItems = [apiKeyQueryItem]
        
        
        let url = components.url?.absoluteString
        
        let params: [String: Any] = ["session_id" : Utility.sessionId]
        
        RxAlamofire
            .requestJSON(.delete,
                                url!,
                                parameters: params,
                                encoding: JSONEncoding.default,
                                headers: nil)
            //.debug()
            .subscribe(onNext: { (headerResponse, json) in
            let jsonData = JSON(json)
            let statusCode:Int = headerResponse.statusCode
            if let dict = jsonData.dictionaryObject {
                let code = HTTPResponseCode(rawValue:statusCode) ?? .Unknown
                let apiResponse = NetworkHelper.checkResponse(statusCode: code, responseDict: dict)
                self.rxSignoutResponse.onNext(apiResponse)
                
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
            self.rxSignoutResponse.onError(error)
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
    
    func postFavoriteShowApi(isFavorite: Bool, mediaId: Int) {
        
        let ud = UserDefaults.standard
        let profileId: Int = ud.integer(forKey: UserDefaultValues.PersonalInfo.profileId)
        
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/account/\(profileId)/favorite"
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        let sessionIdQueryItem = URLQueryItem(name: "session_id", value: Utility.sessionId)
        components.queryItems = [apiKeyQueryItem, sessionIdQueryItem]
        
        
        let url = components.url?.absoluteString
        
        let params: [String: Any] = ["media_type" : "tv",
                                     "media_id"  : mediaId,
                                     "favorite"  : isFavorite]
        RxAlamofire
            .requestJSON(.post,
                                url!,
                                parameters: params,
                                encoding: JSONEncoding.default,
                                headers: nil)
            //.debug()
            .subscribe(onNext: { (headerResponse, json) in
            let jsonData = JSON(json)
                
            let statusCode:Int = headerResponse.statusCode
            if let dict = jsonData.dictionaryObject {
                let code = HTTPResponseCode(rawValue:statusCode) ?? .Unknown
                let apiResponse = NetworkHelper.checkResponse(statusCode: code, responseDict: dict)
                self.rxSetFavoriteMediaResponse.onNext(apiResponse)
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
            self.rxSetFavoriteMediaResponse.onError(error)
            Session.expired()
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
    
    func getFavoriteShowsListApi() {
        
        let ud = UserDefaults.standard
        let profileId: Int = ud.integer(forKey: UserDefaultValues.PersonalInfo.profileId)
        
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/account/\(profileId)/favorite/tv"
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: tmdbKey)
        let languageQueryItem = URLQueryItem(name: "language", value: "en-US")
        let sessionIdQueryItem = URLQueryItem(name: "session_id", value: Utility.sessionId)
        let sortingQueryItem = URLQueryItem(name: "sort_by", value: "created_at.asc")
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        components.queryItems = [apiKeyQueryItem, languageQueryItem, sessionIdQueryItem, sortingQueryItem, pageQueryItem]
        
        
        let url = components.url?.absoluteString
        
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
                self.rxGetFavoriteMediaListResponse.onNext(apiResponse)
            }
                
        }, onError: {  (error) in
            print("API Response \(String(describing: url))\nError:\(error.localizedDescription)")
            self.rxGetFavoriteMediaListResponse.onError(error)
        }, onDisposed: {
            print("Diposing API")
        }).disposed(by: disposeBag)
    }
}
