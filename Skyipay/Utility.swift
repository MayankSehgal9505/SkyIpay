//
//  UserDefaults.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
import UIKit
import RESideMenu
import CountryPickerView

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
    static func setDeviceToken(deviceToken:String) {
        defaults.set(deviceToken, forKey: "deviceToken")
    }
    static func getDeviceToken()-> String {
        defaults.string(forKey: "deviceToken") ?? "asdfsfsdfsdfdhdfghfghd54745645643546536"
    }
    static func setAccessToken(accessToken:String) {
        defaults.set(accessToken, forKey: "accessToken")
    }
    static func getAccessToken()-> String {
        defaults.string(forKey: "accessToken") ?? ""
    }
    static func setUserID(userID:Int) {
        defaults.set(userID, forKey: "userID")
    }
    static func getUserID()-> Int? {
        defaults.integer(forKey: "userID")
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
    
    static func VerificationPendingRootVC() {
        let verificationVC = VerifictionPendingVC()
        let rootVC = UINavigationController(rootViewController: verificationVC)
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    static func loadAllCountries() -> Array<Country>{
        var countries = [Country]()
        let bundle = Bundle(for: CountryPickerView.self)
        guard let jsonPath = bundle.path(forResource: "CountryPickerView.bundle/Data/CountryCodes", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                return countries
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization
            .ReadingOptions.allowFragments)) as? Array<Any> {
            
            for jsonObject in jsonObjects {
                
                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
                    continue
                }
                guard let id = countryObj["id"] as? Int, let isoCode = countryObj["iso"] as? String,
                    let name = countryObj["nicename"] as? String,
                    let dialCode = countryObj["dial_code"] as? Int, let currency = countryObj["currency"] as? String else {
                        continue
                }
                
                let country = Country(countryId: id, countryISOCode: isoCode, countryName: name, countryDialCode: dialCode, countryCurrency: currency)
                countries.append(country)
            }
        }
        return countries
    }
    static func classFromString(_ className: String) -> AnyClass! {

        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

        /// get 'anyClass' with classname and namespace
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!

        // return AnyClass!
        return cls
    }
}
