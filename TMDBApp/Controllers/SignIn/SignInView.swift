//
//  SignInView.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation

protocol SignInView {
    func validateSignIn()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func navigateToHome()
    func loadTokenFromServer(token: String)
    func signInFailed(messageApi: String)
}
