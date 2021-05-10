//
//  Delegates.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation

@objc protocol CoreConnectionDelegate: class {
    ///Conection Events
    @objc optional func didInternetConnect()
    @objc optional func didInternetDisconnect()
}

protocol TvFavoriteDelegate: class {
    func didFavoriteShow(message: String)
}
