//
//  TransferDetails.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
import SwiftyJSON
import CountryPickerView

struct TransferDetails {
    //MARK: Variable
    var transferCountry = Country()
    var transferFee = ""
    var transferTax = ""
    var transferAmout = ""
    var transferTotal = ""
    var transferExchage = ""
    var transferAmountExchange = ""
    var transferFeeExchange = ""
    var totalAmout = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
    }
}
