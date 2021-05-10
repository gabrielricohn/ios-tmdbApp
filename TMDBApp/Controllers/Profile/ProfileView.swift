//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation

protocol ProfileView {
    func retrieveProfileInfo()
    func loadProfileDataFromApi(profile: [Profile])
    func loadFavoriteShowsDataFromApi(favoriteShows: [FavoriteShows])
}
