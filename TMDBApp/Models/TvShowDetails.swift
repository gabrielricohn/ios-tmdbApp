//
//  TvShowDetails.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import ObjectMapper

class TvShowDetails: Mappable {
    
    var bgImage: String = ""
    var rating: Double = 0.0
    var showName: String = ""
    var createdBy: Array<TvShowAuthor> = Array<TvShowAuthor>()
    var summary: String = ""
    var seasons: Array<TvSeasons> = Array<TvSeasons>()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        bgImage <- map["backdrop_path"]
        rating <- map["vote_average"]
        createdBy <- map["created_by"]
        showName <- map["name"]
        summary <- map["overview"]
        seasons <- map["seasons"]
    }

}

class TvShowAuthor: Mappable {
    var authorName: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        authorName <- map["name"]
    }
}

class TvSeasons: Mappable {
    var airDate: String = ""
    var season: String = ""
    var poster: String = ""
    var seasonNumber: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        airDate <- map["air_date"]
        season <- map["name"]
        poster <- map["poster_path"]
        seasonNumber <- map["season_number"]
    }
}
