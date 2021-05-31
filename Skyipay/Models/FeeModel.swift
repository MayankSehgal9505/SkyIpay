//
//  FeeModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 31/05/21.
//

import Foundation
import SwiftyJSON

struct FeeModel {
    enum FeeType : Int{
        case percentage = 1
        case fixed
    }
    //MARK: Variable
    var feeID = 0
    var feeType: FeeType = .fixed
    var feeValue = 0
    var currency = ""
    var minAmount = 0
    
    var reasonNote = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.feeID = json["id"].intValue
        if let feeTypeObj = FeeType.init(rawValue: json["fee_type"].intValue) {
            feeType = feeTypeObj
        }
        self.feeValue = json["fee"].intValue
        self.currency = json["currency"].stringValue
        self.minAmount = json["min_amount_for_fee"].intValue
    }
}
