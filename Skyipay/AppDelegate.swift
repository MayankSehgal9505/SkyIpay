//
//  AppDelegate.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 16/04/21.
//

import UIKit
import IQKeyboardManager
import RESideMenu
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        setRootVC()
        registerForPushNotifications()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.sharedInstance.saveContext()
    }

    //MARK:- Internal methods
    private func setRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if (Defaults.isAppAlreadyLaunchedOnce()) {
            if (Defaults.isUserLoggedIn()) {
                Utility.setHomeRootVC()
            } else {
                Utility.loginRootVC()
            }
        } else {
            setWalkThroughRootVC()
        }
    }
    
    private func setWalkThroughRootVC() {
        let walkthroughVC = WalkthroughVC()
        let rootVC = UINavigationController(rootViewController: walkthroughVC)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    private func loginRootVC() {
        let loginVC = VerifictionPendingVC()
        let rootVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func registerForPushNotifications() {
          UNUserNotificationCenter.current().delegate = self
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
              (granted, error) in
              print("Permission granted: \(granted)")
              // 1. Check if permission granted
              guard granted else { return }
              // 2. Attempt registration for remote notifications on the main thread
              DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
              }
          }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // 1. Convert device token to string
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         // 2. Print device token to use for PNs payloads
         print("Device Token: \(token)")
        Defaults.setDeviceToken(deviceToken: token)
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("Failed to register for remote notifications with error: \(error)")
     }
}

