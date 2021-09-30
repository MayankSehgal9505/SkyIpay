//
//  RecipientDetail.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 31/05/21.
//

import Foundation
import SwiftyJSON
import CountryPickerView
struct RecipientDetail {
    //MARK: Variable
    var recipientFirstName = ""
    var recipientMiddleName = ""
    var recipientSurName = ""
    var recipientEmail = ""
    var recipientAddress = ""
    var recipientCity = ""
    var recipientCountry = Country()

    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
    }
}
