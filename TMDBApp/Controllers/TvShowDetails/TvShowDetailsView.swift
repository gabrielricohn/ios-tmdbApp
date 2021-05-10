//
//  TvShowDetailsView.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation

protocol TvShowDetailsView {
    func loadDescriptionInfoFromServer(tvDetails: [TvShowDetails])
    func loadCastInfoFromServer(tvCast: [TvCastAndCrew])
}
