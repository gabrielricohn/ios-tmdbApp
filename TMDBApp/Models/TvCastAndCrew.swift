//
//  TvCastAndCrew.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import ObjectMapper

class TvCastAndCrew: Mappable {
    
    var knownForRole: String = ""
    var name: String = ""
    var characterPlaying: String = ""
    var profilePicture: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        knownForRole <- map["known_for_department"]
        name <- map["original_name"]
        characterPlaying <- map["character"]
        profilePicture <- map["profile_path"]
    }

}
