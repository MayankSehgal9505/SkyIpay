//
//  AppDelegate.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 16/04/21.
//

import UIKit
import IQKeyboardManager
import RESideMenu
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        setRootVC()
        return true
    }


    //MARK:- Internal methods
    private func setRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if (Defaults.isAppAlreadyLaunchedOnce()) {
            if (Defaults.isUserLoggedIn()) {
                Utility.setHomeRootVC()
            } else {
                Utility.setHomeRootVC()
            }
        } else {
            Utility.setHomeRootVC()
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
}

