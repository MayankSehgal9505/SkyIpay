//
//  CurrencyConverterModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/09/21.
//

import Foundation
import SwiftyJSON

struct CurrencyConverterModel {
    //MARK: Variable
    var currencyConverterID = ""
    var currencyConverterCountry = ""
    var currencyConverterBaseCurrency = ""
    var currencyConverterCountryCurrency = ""
    var currencyConverterRate = ""

    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.currencyConverterID = json["id"].stringValue
        self.currencyConverterCountry = json["country"].stringValue
        self.currencyConverterBaseCurrency = json["base_currency"].stringValue
        self.currencyConverterCountryCurrency = json["currency"].stringValue
        self.currencyConverterRate = json["rate"].stringValue
    }
}
