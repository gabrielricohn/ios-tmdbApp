//
//  TvShowDetailsPresenter.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import SwiftyJSON

class TvShowDetailsPresenter: BasePresenter {
    typealias View = TvShowDetailsView
    var tvDetailsView: TvShowDetailsView?
    var disposeBag = DisposeBag()
    
    fileprivate let tmdbService : TmdbService
    var getTvDetailsObservable: Disposable?
    var getTvCastObservable: Disposable?
    var getFavoriteShowObservable: Disposable?
    
    init(tmdbService: TmdbService) {
        self.tmdbService = tmdbService
    }
    
    func attachView(view: TvShowDetailsView) {
        self.tvDetailsView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        disposeBag = DisposeBag()
        getTvDetailsObservable?.dispose()
        getTvCastObservable?.dispose()
        getFavoriteShowObservable?.dispose()
    }
    
    func getTvShowDetails(category: TvCategory, showId: String) {
        tmdbService.getTvShowsCategoryApi(tvCategory: category, showId: showId)
        
        getTvDetailsObservable = tmdbService.rxGetTvDescriptionResponse.subscribe(onNext: { (response) in
            if response.status {
                
                let jsonData =  JSON(response.data)
                
                //Obteniendo las tarjetas del servidor
                if let dataShows = jsonData.rawString(){
//                    print(dataShows)
                    
                    if let tvDetails = Mapper<TvShowDetails>().mapArray(JSONString: dataShows) {
                        print(tvDetails)
//                        self.homeView?.loadInfoFromServer(shows: tvShows)
                        self.tvDetailsView?.loadDescriptionInfoFromServer(tvDetails: tvDetails)
                    }

                }
            }
        }, onError: {(error) in
                
        }, onCompleted: {
            
        })
        
        getTvDetailsObservable?.disposed(by: disposeBag)
    }
    
    func getTvCast(category: TvCategory, showId: String) {
        tmdbService.getTvShowsCategoryApi(tvCategory: category, showId: showId)
        
        getTvCastObservable = tmdbService.rxGetTvCastResponse.subscribe(onNext: { (response) in
            if response.status {
                
                let jsonData =  JSON(response.data)
                
                //Obteniendo las tarjetas del servidor
                if let dataShows = jsonData["cast"].rawString(){
                    print(dataShows)
                    
                    if let tvCast = Mapper<TvCastAndCrew>().mapArray(JSONString: dataShows) {
                        
                        self.tvDetailsView?.loadCastInfoFromServer(tvCast: tvCast)
                        
                    }
                }
            }
        }, onError: {(error) in
                
        }, onCompleted: {
            
        })
        
        getTvCastObservable?.disposed(by: disposeBag)
    }
    
    func setFavoriteShow(isFavorite: Bool, showId: Int, completion:@escaping (Bool, String) -> ()) {
        tmdbService.postFavoriteShowApi(isFavorite: isFavorite, mediaId: showId)
        
        if !tmdbService.rxSetFavoriteMediaResponse.hasObservers {
            
            getTvCastObservable = tmdbService.rxSetFavoriteMediaResponse.subscribe(onNext: { (response) in
                
                let jsonData =  JSON(response.data)
                
                if let data = jsonData["status_message"].rawString(){
                    completion(true, data)
                }
                
            }, onError: {(error) in
    
            }, onCompleted: {
                
            })
            
            getTvCastObservable?.disposed(by: disposeBag)
            
        }
    
    }
    
}
