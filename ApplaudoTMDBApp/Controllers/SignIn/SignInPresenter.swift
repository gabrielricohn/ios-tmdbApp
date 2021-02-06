//
//  SignInPresenter.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation

class SignInPresenter: BasePresenter {
    
    typealias View = SignInView
    var signInView: SignInView?
    
    var signInController = SignInController()
    
    func attachView(view: SignInView) {
        self.signInView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        
    }
    
    func checkLogInCredentials(username: String, password: String) {
        signInView?.showLoadingIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            print("Funciona!")
            
            self.signInView?.hideLoadingIndicator()
            
            self.signInView?.navigateToHome()
        
        })
    }
    
}
