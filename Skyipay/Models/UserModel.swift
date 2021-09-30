//
//  UserModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import Foundation
import SwiftyJSON
struct UserModel {
    var userID : Int = 0
    var firstName: String = ""
    var lastname: String = ""
    var userName : String = ""
    var email: String = ""
    var dialCode: String = ""
    var userPhoneNumber:String = ""
    var userGender:String = ""
    var userDOB:String = ""
    var userVerified: VerificationStatus = .ongoing
    var userImageUrl:String = ""
    var userAddress: Array<AddressModel> = Array<AddressModel>()
    var documents: DocumentsModel = DocumentsModel()
    var password: String = ""
    init() {
    }
    
    init(JsonDashBoard: JSON) {
        userID = JsonDashBoard["id"].intValue
        firstName = JsonDashBoard["first_name"].stringValue
        lastname = JsonDashBoard["last_name"].stringValue
        userName = JsonDashBoard["username"].stringValue
        email = JsonDashBoard["email"].stringValue
        dialCode = JsonDashBoard["dial_code"].stringValue
        userPhoneNumber = JsonDashBoard["phone"].stringValue
        userGender = JsonDashBoard["gender"].stringValue
        userDOB = JsonDashBoard["dob"].stringValue
        if let verificationStatus =  VerificationStatus.init(rawValue: Int(JsonDashBoard["is_verify"].stringValue) ?? 0) {
            userVerified = verificationStatus
        }
        userImageUrl = JsonDashBoard["profile_image"].stringValue
        for address in JsonDashBoard["address"].arrayValue {
            let addressModel =  AddressModel.init(JsonDashBoard: address)
            userAddress.append(addressModel)
        }
        documents = DocumentsModel.init(JsonDashBoard: JsonDashBoard["document"])
    }
}
