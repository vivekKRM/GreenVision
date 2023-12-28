//
//  SceneDelegate.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit
import GooglePlaces
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var storyboardName = String()
    var counter = 0
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let appWindow = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: appWindow)
//        makeRoot()
//        window?.makeKeyAndVisible()
        GMSPlacesClient.provideAPIKey("AIzaSyBS5nIuVZFyJHD18sgBgk25roDshPpVci0")

      
    }
    
    static func getWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static func resetViewController() {
        let window = getWindow()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func logout() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        NotificationCenter.default.removeObserver(self)
        let VC = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let centerNavVC = UINavigationController(rootViewController: VC)
        centerNavVC.isNavigationBarHidden = true
        UserDefaults.standard.setValue(false, forKey: "signed")
        window?.rootViewController = centerNavVC
    }
   
    func makeRoot()
    {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            storyboardName = "Main"
            let VC = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
            let centerNavVC = UINavigationController(rootViewController: VC)
            centerNavVC.isNavigationBarHidden = true
            window?.rootViewController = centerNavVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Great1")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Great2")
        
//        NotificationCenter.default.post(name: Notification.Name("NotificationRefresh"), object: nil)
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Great3")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Great4")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Great5")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

