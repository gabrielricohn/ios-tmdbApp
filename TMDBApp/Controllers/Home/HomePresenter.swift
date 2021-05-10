//
//  HomePresenter.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 6/2/21.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import SwiftyJSON

class HomePresenter: BasePresenter {
    
    typealias View = HomeView
    var homeView: HomeView?
    var disposeBag = DisposeBag()
    
    fileprivate let tmdbService : TmdbService
    var getTvShowsObservable: Disposable?
    
    init(tmdbService: TmdbService) {
        self.tmdbService = tmdbService
    }
    
    func attachView(view: HomeView) {
        self.homeView = view
    }
    
    func detachView() {
        
    }
    
    func destroy() {
        disposeBag = DisposeBag()
        getTvShowsObservable?.dispose()
    }
    
    func fetchTvShows(category: TvCategory) {
        tmdbService.getTvShowsCategoryApi(tvCategory: category, showId: "")
        
        if !tmdbService.rxGetTvShowsCategoryResponse.hasObservers {
            getTvShowsObservable = tmdbService.rxGetTvShowsCategoryResponse.subscribe(onNext: { (response) in
                if response.status {
                    
                    let jsonData =  JSON(response.data)
                    
                    //Obteniendo las tarjetas del servidor
                    if let dataShows = jsonData["results"].rawString(){
                        print(dataShows)
                        
                        if let tvShows = Mapper<TvShows>().mapArray(JSONString: dataShows) {
                            self.homeView?.loadInfoFromServer(shows: tvShows)
                        }
                    }
                }
            }, onError: {(error) in
                    
            }, onCompleted: {
                
            })
            
            getTvShowsObservable?.disposed(by: disposeBag)
        }

    }
    
}
