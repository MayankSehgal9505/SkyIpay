//
//  UserModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import Foundation
import UIKit

final class UserData: NSObject {
   static let sharedInstance = UserData()

    //User properties
    var userID = 0
    var userModel = UserModel()
    var rootVC: UIViewController = UIViewController()
    //SendMoney In Singleton classes
    var cachedControllers = [[String:UIViewController]]()
    var selectedTab:Tabs = .transfer
   private override init() { }
}
