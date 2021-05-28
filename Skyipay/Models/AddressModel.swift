//
//  AddressModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 14/05/21.
//

import Foundation
import SwiftyJSON
import CountryPickerView
struct AddressModel {
    var addressID: Int = 0
    var userID: Int = 0
    var addressLabel: String = ""
    var address: String = ""
    var city:String = ""
    var state:String = ""
    var postcode:String = ""
    var country:String = ""
    var country_iso:String = ""
    var dial_code:String = ""
    var telephone:String = ""
    var address_type:Int = 0
    var countryModel: Country = Country()
    init() {
    }
    
    init(JsonDashBoard: JSON) {
        addressID = JsonDashBoard["id"].intValue
        userID = JsonDashBoard["user_id"].intValue
        addressLabel = JsonDashBoard["label"].stringValue
        address = JsonDashBoard["address"].stringValue
        city = JsonDashBoard["city"].stringValue
        state = JsonDashBoard["state"].stringValue
        postcode = JsonDashBoard["postcode"].stringValue
        country = JsonDashBoard["country"].stringValue
        country_iso = JsonDashBoard["country_iso"].stringValue
        dial_code = JsonDashBoard["dial_code"].stringValue
        telephone = JsonDashBoard["telephone"].stringValue
        address_type = JsonDashBoard["address_type"].intValue
        countryModel = Utility.loadAllCountries().filter({ (country) -> Bool in
            "\(country.countryId)" == self.country
        }).first!
        
    }
    
//    private func loadAllCountries() -> Array<Country>{
//        var countries = [Country]()
//        let bundle = Bundle(for: CountryPickerView.self)
//        guard let jsonPath = bundle.path(forResource: "CountryPickerView.bundle/Data/CountryCodes", ofType: "json"),
//            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
//                return countries
//        }
//
//        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization
//            .ReadingOptions.allowFragments)) as? Array<Any> {
//
//            for jsonObject in jsonObjects {
//
//                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
//                    continue
//                }
//                guard let id = countryObj["id"] as? Int, let isoCode = countryObj["iso"] as? String,
//                    let name = countryObj["nicename"] as? String,
//                    let dialCode = countryObj["dial_code"] as? Int, let currency = countryObj["currency"] as? String else {
//                        continue
//                }
//
//                let country = Country(countryId: id, countryISOCode: isoCode, countryName: name, countryDialCode: dialCode, countryCurrency: currency)
//                countries.append(country)
//            }
//        }
//        return countries
//    }
}
