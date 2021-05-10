//
//  Constants.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 5/2/21.
//

import Foundation

class ApiConstants {
    
    struct ApiResponse {
        static let message = "message"
        static let data = "data"
    }
}

struct UserDefaultValues {
    
    struct Tokens {
        static let requestToken = "user_session_token"
        static let sessionId = "session_id"
    }
    
    struct PersonalInfo {
        static let profileId = "user_id"
    }
    
}
