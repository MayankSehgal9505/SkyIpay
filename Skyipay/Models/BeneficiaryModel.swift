//
//  BeneficiaryModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/05/21.
//

import Foundation
import SwiftyJSON

struct BeneficiaryModel {

    enum BeneficiaryStatus: String {
        case verified = "1"
        case notVerified = "0"
        
        var beneficiaryStatusText: String {
            switch self {
            case .verified: return BeneficiaryVCConstants.verified
            default: return BeneficiaryVCConstants.notVerified
            }
        }
        
        var beneficiaryStatusImg: String {
            switch self {
            case .verified: return "success"
            default: return BeneficiaryVCConstants.notVerified
            }
        }
    }
    //MARK: Variable
    var beneficiaryID = ""
    var beneficiaryUserID = ""
    var beneficiaryName = ""
    var beneficiaryBankName = ""
    var beneficiaryAccountNumber = ""
    var beneficiaryDialCode = ""
    var beneficiaryPhoneNumber = ""
    var beneficiaryEmail = ""
    var beneficiaryDOB = ""
    var beneficiaryCountryID = ""
    var beneficiaryStatus:BeneficiaryStatus = .notVerified
    var beneficiaryCreationDate = ""
    var beneficiaryUpdateDate = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.beneficiaryID = json["id"].stringValue
        self.beneficiaryUserID = json["user_id"].stringValue
        self.beneficiaryName = json["name"].stringValue
        self.beneficiaryBankName = json["bank_name"].stringValue
        self.beneficiaryAccountNumber = json["ac_no"].stringValue
        self.beneficiaryDialCode = json["dial_code"].stringValue
        self.beneficiaryPhoneNumber = json["phone"].stringValue
        self.beneficiaryEmail = json["email"].stringValue
        self.beneficiaryDOB = json["dob"].stringValue
        self.beneficiaryCountryID = json["country_id"].stringValue
        if let beneficiaryStatus = BeneficiaryStatus.init(rawValue: json["status"].stringValue) {
            self.beneficiaryStatus = beneficiaryStatus
        }
        self.beneficiaryCreationDate = json["created_at"].stringValue
        self.beneficiaryUpdateDate = json["updated_at"].stringValue
    }
}
