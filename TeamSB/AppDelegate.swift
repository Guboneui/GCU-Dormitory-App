//
//  AppDelegate.swift
//  TeamSB
//
//  Created by 구본의 on 2021/06/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      
        print(UserDefaults.standard.bool(forKey: "autoLoginState"))
        
//        if UserDefaults.standard.bool(forKey: "autoLoginState") == false {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//            window?.rootViewController = loginVC
//            window?.makeKeyAndVisible()
//
//        } else {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let testVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
//            window?.rootViewController = testVC
//            window?.makeKeyAndVisible()
//        }


        
        
        
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


}

