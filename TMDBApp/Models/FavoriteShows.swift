//
//  FavoriteShows.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 9/2/21.
//

import Foundation
import ObjectMapper

class FavoriteShows: Mappable {
    
    var id: Int = 0
    var poster: String = ""
    var originalName: String = ""
    var rating: Double = 0.0
    var overview: String = ""
    var showDate: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        id <- map["id"]
        poster <- map["poster_path"]
        originalName <- map["original_name"]
        rating <- map["vote_average"]
        overview <- map["overview"]
        showDate <- map["first_air_date"]
    }

}
