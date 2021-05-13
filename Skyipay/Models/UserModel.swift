//
//  UserModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import Foundation
import SwiftyJSON
import SDWebImage
import UIKit
struct UserModel {
    var firstName: String = ""
    var lastname: String = ""
    var email: String = ""
    var countryCode: String = ""
    var userNumber:String = ""
    var userImageUrl:String = ""
    var dob:String = ""
    var languages:String = ""
    var birthCountry:String = ""
    var userID:String = ""
    var userName:String = ""
    var otpID:String = ""
    var password: String = ""
    var gender: String = ""
    var nationality = ""
    init() {
    }
    
    init(JsonDashBoard: JSON) {
        firstName = JsonDashBoard["firstname"].stringValue
        lastname = JsonDashBoard["lastname"].stringValue
        email = JsonDashBoard["email"].stringValue
        countryCode = JsonDashBoard["country_code"].stringValue
        userImageUrl = JsonDashBoard["image"].stringValue
        languages = JsonDashBoard["languages"].stringValue
        birthCountry = JsonDashBoard["country_birth"].stringValue
        dob = JsonDashBoard["dob"].stringValue
        var userIDValue = ""
        if (JsonDashBoard["user_id"].stringValue.count > 0) {
            userIDValue = JsonDashBoard["user_id"].stringValue
        } else if (JsonDashBoard["id"].stringValue.count > 0) {
            userIDValue = JsonDashBoard["id"].stringValue
        }else if (JsonDashBoard["userId"].stringValue.count > 0) {
            userIDValue = JsonDashBoard["userId"].stringValue
        }
        userID = userIDValue
        otpID = JsonDashBoard["otp_id"].stringValue
        var phoneNumber = ""
        if (JsonDashBoard["phoneNumber"].stringValue.count > 0) {
            phoneNumber = JsonDashBoard["phoneNumber"].stringValue
        } else if (JsonDashBoard["phonenumber"].stringValue.count > 0) {
            phoneNumber = JsonDashBoard["phonenumber"].stringValue
        }
        userNumber = phoneNumber
        password = JsonDashBoard["password"].stringValue
        gender = JsonDashBoard["gender"].stringValue
        nationality = JsonDashBoard["nationality"].stringValue

    }
}
