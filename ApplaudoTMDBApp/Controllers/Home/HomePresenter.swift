//
//  HomePresenter.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 6/2/21.
//

import Foundation

class HomePresenter: BasePresenter {
    
    typealias View = HomeView
    var homeView: HomeView?
    
    func attachView(view: HomeView) {
        self.homeView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        
    }
    
}
