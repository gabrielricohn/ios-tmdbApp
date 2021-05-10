//
//  Session.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation
import UIKit

class Session {
    
    class func expired() {
        
        let apiService = TmdbService()
        apiService.logoutAPI()
        
//        Utility.unsubscribeToNotifications(topic: Utility.customerFcmTopic)
        
//        let realm:Realm = DatabaseManager.shared.realm
        
        let userDefaults = UserDefaults.standard
        Utility.removeDataInKeychain(key: UserDefaultValues.Tokens.requestToken)
        
        userDefaults.removeObject(forKey: UserDefaultValues.Tokens.sessionId)
        userDefaults.removeObject(forKey: UserDefaultValues.PersonalInfo.profileId)
//        userDefaults.removeObject(forKey: UserDefaultValues.User.lastName)
//        //userDefaults.removeObject(forKey: UserDefaultValues.User.countryCode)
//        //userDefaults.removeObject(forKey: UserDefaultValues.User.phone)
//        //userDefaults.removeObject(forKey: UserDefaultValues.User.email)
//        userDefaults.removeObject(forKey: UserDefaultValues.User.customerFcmTopic)
//
//        userDefaults.removeObject(forKey: UserDefaultValues.User.rtnName)
//        userDefaults.removeObject(forKey: UserDefaultValues.User.rtnNumber)
//
//        userDefaults.removeObject(forKey: UserDefaultValues.User.lastPickupAddress)
//        userDefaults.removeObject(forKey: UserDefaultValues.User.lastLatitude)
//        userDefaults.removeObject(forKey: UserDefaultValues.User.lastLongitude)
        
//        try! realm.write {
//         realm.deleteAll()
//        }
        
        /// Volver al Login
        
        DispatchQueue.main.async(execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let splashVC = storyboard.instantiateViewController(withIdentifier: "SignInController")
            let rootNaviVC: UINavigationController = UINavigationController(rootViewController: splashVC)
            let window = UIApplication.shared.keyWindow
            window?.rootViewController = rootNaviVC
        })
    }
}
