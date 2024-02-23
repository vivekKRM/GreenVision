//
//  AppDelegate.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications
import Firebase
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSServices.provideAPIKey("AIzaSyCrCGPXfswRFDdMzSdEaGBnZiz9LQNFTCA")
//        UINavigationBar.appearance().barTintColor = UIColor.init(hexString: "528E4A")

        //Push Notification
        FirebaseApp.configure()//commented on 26 Sep
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: authOptions, completionHandler: {_ ,_ in })
           application.registerForRemoteNotifications()
           UNUserNotificationCenter.current().delegate = self
           Messaging.messaging().delegate = self
        } else {
           let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
           application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        //Push Notification
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
//MARK: Firebase Push Notification
extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
            let userInfo:NSDictionary = notification.request.content.userInfo as NSDictionary
            print(userInfo)
        let dict:NSDictionary = userInfo["aps"] as? NSDictionary ?? [:]
        let data:NSDictionary = dict["alert"] as?  NSDictionary ?? [:]
        print("APS Sound Display")
            print(dict)
            print("Alert Data")
            print(data)
    
        let dictData:String = userInfo["gcm.notification.type"] as? String ?? ""
        print(dictData)
        if dictData == "1"
        {
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifiercare"), object: nil)
            //Coach Chat
        }
            NotificationCenter.default.post(name: Notification.Name("NotificationBadge"), object: nil)
        
        print(notification.request.content.title)
        print("📲📲📲 recieved")
               if notification.request.content.title.contains("Message")
               {
                   print("sub")
                   print(notification.request.content.subtitle)
                   print("body")
                   print(notification.request.content.body)
                   print("it containt DM ⏰")
               }
    }

}
//MARK: Push Notification
extension AppDelegate : MessagingDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dictaps = userInfo["aps"] as? NSDictionary ?? [:]
        let message = dictaps["alert"] as? String ?? ""
        let badge = dictaps["badge"] as? Int ?? 0
        let dictData:String = userInfo["gcm.notification.type"] as? String ?? ""
        switch application.applicationState {
            case .active:
                print("do stuff in case App is active")
            if dictData == "1"
            {
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierca"), object: nil)
                //coach chat
            }else if dictData == "2"{
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                //open Notification
            }
            case .background:
                print("do stuff in case App is in background")
            if dictData == "1"
            {
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierca"), object: nil)
                //coach chat
            }else if dictData == "2"{
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                //open Notification
            }
            case .inactive:
                print("do stuff in case App is inactive")
            if dictData == "1"
            {
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierca"), object: nil)
                //coach chat
            }else if dictData == "2"{
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                //open Notification
            }
            }
        
        print(message)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
          let dataDict: [String: String] = ["token": fcmToken ?? ""]
        UserDefaults.standard.set(fcmToken ?? "", forKey: "fcm")
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

              print("user clicked on the notification")
              let userInfo = response.notification.request.content.userInfo
                let content = UNMutableNotificationContent()
                  //Default sound
                  content.sound = UNNotificationSound.default
                  //Play custom sound
                  content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "message"))
                  
              print(userInfo)
        let dictData:String = userInfo["gcm.notification.type"] as? String ?? ""
        print(dictData)
      
        
        let dict:NSDictionary = userInfo["aps"] as? NSDictionary ?? [:]
        print(dict)
        let alertdict = dict["alert"] as? NSDictionary ?? [:]
        print("Key for Notification\(dictData)")
        
        if dictData == "1"
        {
//            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierca"), object: nil)
            //coach chat
        } else if dictData == "2"{
            //when open and click on live notification
//            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            //open Notification
        }else{
            
        }
//        completionHandler()
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
}
