//
//  TransferReason.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 31/05/21.
//

import Foundation
import SwiftyJSON

struct TransferReasonModel {
    //MARK: Variable
    var reasonID = ""
    var reasonTitle = ""
    var reasonNote = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.reasonID = json["id"].stringValue
        self.reasonTitle = json["title"].stringValue
        self.reasonNote = json["note"].stringValue
    }
}
