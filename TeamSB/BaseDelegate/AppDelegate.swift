import UIKit
import IQKeyboardManager
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    let gcmMessageIDKey = "gcm.Message_id"
    var window: UIWindow?

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//           {
//            completionHandler([.banner, .badge, .sound])
//           }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// 앱이 foreground  상태일 때 Push 받으면 alert를 띄워준다
        completionHandler([.banner, .sound])
      }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
      
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: { didAllow, Error in
//                print(didAllow)
//                UserDefaults.standard.set(didAllow, forKey: "alertAccess")
//            }
//            
//          )
//        } else {
//          let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }

        //application.registerForRemoteNotifications()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
   
    
    func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
  
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
            
        }

        // Print full message.
        print(userInfo)
      }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       print(">> 앱이 종료됩니다😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍😍")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
        
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func requestSceneSessionDestruction(_ application: UIApplication) {
        
    }
   
}



extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        
        
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print(">>🐣 기기 FCM 토큰 정보: \(token)")
        UserDefaults.standard.set(token, forKey: "FCMToken")
        //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
        }
        }
    }

}




//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate {
//  // Receive displayed notifications for iOS 10 devices.
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
//                                -> Void) {
//    let userInfo = notification.request.content.userInfo
//    print(userInfo)
//
//    completionHandler([[.banner, .badge, .sound]])
//  }
//
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler completionHandler: @escaping () -> Void) {
//    let userInfo = response.notification.request.content.userInfo
//
//    // ...
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // Messaging.messaging().appDidReceiveMessage(userInfo)
//    // Print full message.
//    print(userInfo)
//
//    completionHandler()
//  }
//}
