//
//  HomeView.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 6/2/21.
//

import Foundation

protocol HomeView {
    func retrieveTvShows(categorySelected: TvCategory)
    func loadInfoFromServer(shows: [TvShows])
    func showOptionsMenu()
}
