//
//  AppDelegate.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let reachability = try! Reachability()
    weak var connectionDelegate: CoreConnectionDelegate?
    
//    var connectivityDialog = Modal()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        Utility.removeDataInKeychain(key: UserDefaultValues.Tokens.requestToken)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        if Utility.sessionToken.count == 0 {

            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC:UIViewController = mainStoryboard.instantiateViewController(withIdentifier:"SignInController") as! SignInController
            let navigationController = UINavigationController(rootViewController: rootVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
        } else {

            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC:UIViewController = mainStoryboard.instantiateViewController(withIdentifier:"HomeController") as! HomeController
            let navigationController = UINavigationController(rootViewController: rootVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
        }
        
        /// CONECTIVITY NOTIFICATION
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: Notification.Name("reachabilityChanged"), object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start reachability notifier")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            print("Invalid URL")
            return false
        }
        
        print("components: \(components)")
        
        // Create the deep link
        guard let deeplink = DeepLink(rawValue: host) else {
            print("Deeplink not found: \(host)")
            return false
        }
        
        // Hand off to mainViewController
        let hController = HomeController()
        hController.handleDeepLink(deeplink)
        
        return true
    }

    
    //MARK: - CHECK INTERNET CONNECTION
    
    @objc func reachabilityChanged(note: Notification) {
        /// Try the current status of the internet
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
//            connectivityDialog.dismiss(animated: true)
            connectionDelegate?.didInternetConnect?()
            print("wifi connected")
            break
        case .cellular:
//            connectivityDialog.dismiss(animated: true)
            connectionDelegate?.didInternetConnect?()
            print("3G connected")
            break
        case .none:
            connectionDelegate?.didInternetDisconnect?()
            break
        case .unavailable:
            connectionDelegate?.didInternetDisconnect?()
            break
        }
    }


}

