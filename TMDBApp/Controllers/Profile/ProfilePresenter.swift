//
//  ProfilePresenter.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import SwiftyJSON

class ProfilePresenter: BasePresenter {
    
    typealias View = ProfileView
    var profileView: ProfileView?
    
    var disposeBag = DisposeBag()
    
    fileprivate let tmdbService : TmdbService
    var getProfileObservable: Disposable?
    var getFavoriteShowListObservable: Disposable?
    
    init(tmdbService: TmdbService) {
        self.tmdbService = tmdbService
    }
    
    func attachView(view: ProfileView) {
        self.profileView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        disposeBag = DisposeBag()
        getProfileObservable?.dispose()
        getFavoriteShowListObservable?.dispose()
    }
    
    func fetchProfileInfo(category: TvCategory) {
        tmdbService.getTvShowsCategoryApi(tvCategory: category, showId: "")
        
        if !self.tmdbService.rxGetProfileResponse.hasObservers {
            
            getProfileObservable = tmdbService.rxGetProfileResponse.subscribe(onNext: { (response) in
                if response.status {
                    
                    let jsonData =  JSON(response.data).rawString()
                    
                    if let data = Mapper<Profile>().mapArray(JSONString: jsonData!) {
                        self.profileView?.loadProfileDataFromApi(profile: data)
                    }
                    
                }
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            getProfileObservable?.disposed(by: disposeBag)
            
        }
    }
    
    func getFavoriteShowListFromApi() {
        
        tmdbService.getFavoriteShowsListApi()
        
        if !tmdbService.rxGetFavoriteMediaListResponse.hasObservers {
            
            getFavoriteShowListObservable = tmdbService.rxGetFavoriteMediaListResponse.subscribe(onNext: { (response) in
                
                let jsonData =  JSON(response.data)
                
                if let data = jsonData["results"].rawString(){
                    
                    if let favoriteData = Mapper<FavoriteShows>().mapArray(JSONString: data) {
                        
                        self.profileView?.loadFavoriteShowsDataFromApi(favoriteShows: favoriteData)
                        
                    }
                    
                }
                
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            getFavoriteShowListObservable?.disposed(by: disposeBag)
            
        }
    
    }
}
