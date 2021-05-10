//
//  Profile.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation
import ObjectMapper

class Profile: Mappable {

    var name: String = ""
    var username: String = ""
    var avatar: Avatar!
    var profileId: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map){
        name <- map["name"]
        username <- map["username"]
        avatar <- map["avatar"]
        profileId <- map["id"]
    }

}

class Avatar: Mappable {
    var avatar: TmdbAvatar!
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        avatar <- map["tmdb"]
    }
}

class TmdbAvatar: Mappable {
    var avatarUrl: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        avatarUrl <- map["avatar_path"]
    }
}
