//
//  UserModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import Foundation
import CountryPickerView
import UIKit

final class UserData: NSObject {
   static let sharedInstance = UserData()

    //User properties
    var userPhoneNumber = ""
    var userName = ""
    var userID = 0
    var userModel = UserModel()
    var usercountry = Country()
    var rootVC: UIViewController = UIViewController()
   private override init() { }
}
