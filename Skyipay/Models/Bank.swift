//
//  Bank.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 31/05/21.
//

import Foundation
import SwiftyJSON

struct Bank {
    //MARK: Variable
    var id = 0
    var bankName = ""
    var bankID = 0
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.id = json["id"].intValue
        self.bankName = json["name"].stringValue
        self.bankID = json["bank_id"].intValue
    }
}

