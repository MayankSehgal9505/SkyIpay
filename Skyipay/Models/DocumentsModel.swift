//
//  DocumentsModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 14/05/21.
//

import Foundation
import SwiftyJSON
struct DocumentsModel {    
    var documentID: Int = 0
    var IDCardUrl: String = ""
    var utilityBillsUrl: String = ""
    var bankStatementUrl: String = ""
    var paySlipsUrl:String = ""
    var sourceIncomeUrl:String = ""
    var dobProofUrl:String = ""
    init() {
    }
    
    init(JsonDashBoard: JSON) {
        documentID = JsonDashBoard["document_id"].intValue
        IDCardUrl = JsonDashBoard["id_card"].stringValue
        utilityBillsUrl = JsonDashBoard["utility_bills"].stringValue
        bankStatementUrl = JsonDashBoard["bank_statements"].stringValue
        paySlipsUrl = JsonDashBoard["pay_slips"].stringValue
        sourceIncomeUrl = JsonDashBoard["source_income"].stringValue
        dobProofUrl = JsonDashBoard["dob_proof"].stringValue
    }
}

