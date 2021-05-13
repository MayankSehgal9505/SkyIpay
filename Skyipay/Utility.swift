//
//  UserDefaults.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
import UIKit
import RESideMenu

class Defaults {
    static let defaults = UserDefaults.standard

    static func isAppAlreadyLaunchedOnce()->Bool{
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    static func isUserLoggedIn()->Bool{
        return  defaults.bool(forKey: "isUserLoggedIn") 
    }
    
    static func setUserLoggedIn(userLoggedIn:Bool) {
        defaults.set(userLoggedIn, forKey: "isUserLoggedIn")
    }
    
    static func setUserID(userID:String) {
        defaults.set(userID, forKey: "userID")
    }
    static func getUserID()-> String {
        defaults.string(forKey: "userID") ?? ""
    }
    static func resetDefaults() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != "isAppAlreadyLaunchedOnce" {
                defaults.removeObject(forKey: key)
            }
        }
    }
}


class Utility {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func setHomeRootVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "homeVC") as! UINavigationController
        
        let sideMenuVC = SideMenu()
        
        let reSideMenu = RESideMenu.init(contentViewController: navigationController, leftMenuViewController: sideMenuVC, rightMenuViewController: nil)
        var tabBarController = UITabBarController()
        if ((navigationController.viewControllers.first?.isKind(of: UITabBarController.self)) != nil) {
            tabBarController = navigationController.viewControllers.first! as! UITabBarController
            tabBarController.selectedIndex = 2
        }
        appDelegate.window?.rootViewController = reSideMenu
        appDelegate.window?.makeKeyAndVisible()
    }
    
    static func loginRootVC() {
        let loginVC = LoginVC()
        let rootVC = UINavigationController(rootViewController: loginVC)
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
}
