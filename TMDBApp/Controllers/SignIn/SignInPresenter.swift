//
//  SignInPresenter.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import SwiftyJSON

class SignInPresenter: BasePresenter {
    
    typealias View = SignInView
    var signInView: SignInView?
    
    var signInController = SignInController()
    
    var disposeBag = DisposeBag()
    
    fileprivate let tmdbService : TmdbService
    var getAuthTokenObservable: Disposable?
    var getSignInObservable: Disposable?
    var createSessionIdObservable: Disposable?
    
    init(tmdbService: TmdbService) {
        self.tmdbService = tmdbService
    }
    
    func attachView(view: SignInView) {
        self.signInView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        disposeBag = DisposeBag()
        getAuthTokenObservable?.dispose()
        getSignInObservable?.dispose()
        createSessionIdObservable?.dispose()
    }
    
    func fetchAuthTokenfromApi(completion:@escaping (Bool) -> ()) {
        tmdbService.getTvShowsCategoryApi(tvCategory: .AuthToken, showId: "")
        
        if !self.tmdbService.rxGetAuthTokenResponse.hasObservers {
            
            getAuthTokenObservable = tmdbService.rxGetAuthTokenResponse.subscribe(onNext: { (response) in
                if response.status {
                    
                    let jsonData =  JSON(response.data)
                    
                    if let data = jsonData["request_token"].rawString(){
                        
                        Utility.saveDataInKeychain(key: UserDefaultValues.Tokens.requestToken, value: data)
                        
                        self.signInView?.loadTokenFromServer(token: data)
                        
                    }
                    
                    completion(true)
                    
                } else {
                    
                    completion(false)
                    
                }
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            getAuthTokenObservable?.disposed(by: disposeBag)
        }
        
    }
    
    func checkLogInCredentials(model: SignInDetails) {
        signInView?.showLoadingIndicator()
        
        tmdbService.signInApi(signInParams: model)
        
        if !self.tmdbService.rxSignInResponse.hasObservers {
            
            getSignInObservable = tmdbService.rxSignInResponse.subscribe(onNext: { (response) in
                
                self.signInView?.hideLoadingIndicator()
                
                if response.status {
                    
                    self.createSessionId()
                     
                    self.signInView?.navigateToHome()
                    
                } else {
                    
                    print("error de inicio de sesion")
                    
                    let jsonData =  JSON(response.data)
                    
                    if let data = jsonData["status_message"].rawString(){
                        
                        self.signInView?.signInFailed(messageApi: data)
                        
                    }
                    
                    if let data = jsonData["status_code"].int, data == 33 {

                        Utility.removeDataInKeychain(key: Utility.sessionToken)
                        
                    }
                    
                }
                
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            getSignInObservable?.disposed(by: disposeBag)
            
        }
        
    }
    
    func createSessionId() {
        tmdbService.createSession()
        
        if !self.tmdbService.rxCreateSessionIdResponse.hasObservers {
            
            createSessionIdObservable = tmdbService.rxCreateSessionIdResponse.subscribe(onNext: { (response) in
                
                let jsonData =  JSON(response.data)
                                
                if response.status {
                    
                    if let data = jsonData["session_id"].rawString(){

                        Utility.setDefaultValue(data, forKey: UserDefaultValues.Tokens.sessionId)
                        
                    }
                    
                } else {
                    
                    print("error")
                    
                }
                
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            createSessionIdObservable?.disposed(by: disposeBag)
            
        }
        
    }
    
}
