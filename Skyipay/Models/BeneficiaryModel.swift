//
//  BeneficiaryModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/05/21.
//

import Foundation
import SwiftyJSON
import CountryPickerView

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
    var currentUserID = ""
    var beneficiaryName = ""
    var beneficiaryFirstName = ""
    var beneficiaryMiddleName = ""
    var beneficiaryLastName = ""
    var beneficiaryBankName = ""
    var beneficiaryBankID = ""
    var beneficiaryAccountNumber = ""
    var beneficiaryDialCode = ""
    var beneficiaryPhoneNumber = ""
    var beneficiaryEmail = ""
    var beneficiaryDOB = ""
    var beneficiaryOccupation = ""
    var beneficiaryCountryID = ""
    var beneficiaryStatus:BeneficiaryStatus = .notVerified
    var beneficiaryCreationDate = ""
    var beneficiaryUpdateDate = ""
    var beneficiaryiso3 = ""
    var beneficiaryAddress = ""
    var beneficiaryCity = ""
    var beneficiaryPostCode = ""
    var beneficiaryCountryName = ""
    var countryModel: Country = Country()
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.beneficiaryID = json["id"].stringValue
        self.currentUserID = json["user_id"].stringValue
        self.beneficiaryName = json["name"].stringValue
        self.beneficiaryFirstName = json["first_name"].stringValue
        self.beneficiaryMiddleName = json["middle_name"].stringValue
        self.beneficiaryLastName = json["last_name"].stringValue
        self.beneficiaryBankName = json["bank_name"].stringValue
        self.beneficiaryBankID = json["bank_id"].stringValue
        self.beneficiaryAccountNumber = json["ac_no"].stringValue
        self.beneficiaryDialCode = json["dial_code"].stringValue
        self.beneficiaryPhoneNumber = json["phone"].stringValue
        self.beneficiaryEmail = json["email"].stringValue
        self.beneficiaryDOB = json["dob"].stringValue
        self.beneficiaryOccupation = json["occupation"].stringValue
        self.beneficiaryCountryID = json["country_id"].stringValue
        self.beneficiaryiso3 = json["iso3"].stringValue
        self.beneficiaryAddress = json["address"].stringValue
        self.beneficiaryCity = json["city"].stringValue
        self.beneficiaryPostCode = json["postcode"].stringValue
        self.beneficiaryCountryName = json["country_name"].stringValue
        if let beneficiaryStatus = BeneficiaryStatus.init(rawValue: json["status"].stringValue) {
            self.beneficiaryStatus = beneficiaryStatus
        }
        self.beneficiaryCreationDate = json["created_at"].stringValue
        self.beneficiaryUpdateDate = json["updated_at"].stringValue
        countryModel = Utility.loadAllCountries().filter({ (country) -> Bool in
            "\(country.countryId)" == self.beneficiaryCountryID
        }).first!
    }
}
