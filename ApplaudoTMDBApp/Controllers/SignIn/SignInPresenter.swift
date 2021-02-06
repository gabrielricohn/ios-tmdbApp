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
    
    func attachView(view: SignInView) {
        self.signInView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        
    }
    
}
