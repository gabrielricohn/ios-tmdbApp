//
//  Enums.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 5/2/21.
//

import Foundation

enum TvCategory: Int {
    case Popular = 0, TopRated = 1, OnTv = 2, AiringToday = 3, ShowDetails = 4, CastAndCrew = 5, Profile = 6, AuthToken = 7
}

enum ShowDetails {
    case Summary, Seasons, Cast
}

enum AlertButtons {
    case None, Single, Double
}

enum DeepLink: String {
    case Popular
    case TopRated
    case OnAir
}
