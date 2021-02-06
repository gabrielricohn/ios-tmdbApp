//
//  SignInView.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation

protocol SignInView {
    func validateSignIn(username: String, password: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func navigateToHome()
}
