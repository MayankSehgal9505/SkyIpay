//
//  ActivityModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/04/21.
//

import Foundation
import SwiftyJSON
import UIKit
struct ActivtyModel {
    enum PaymentStatus: String {
        case failed = "failed"
        case success = "completed"
        case pending = "pending"
        
        var paymentStatusImage:UIImage {
            switch self {
            case .failed:
                return UIImage(named: "fail")!
            case .success:
                return UIImage(named: "success")!
            case .pending:
                return UIImage(named: "pending")!
            }
        }
        
        var paymentStatusText:(String,UIColor) {
            switch self {
            case .failed:
                return ("Failed", UIColor.init(red: 219/255, green: 0/255, blue: 15/2255, alpha: 1.0))
            case .success:
                return ("Done", UIColor.init(red: 47/255, green: 80/255, blue: 42/2255, alpha: 1.0))
            case .pending:
                return ("Pending", UIColor.init(red: 220/255, green: 119/255, blue: 49/2255, alpha: 1.0))
            }
        }
        
        var paymentStatusMsg:String {
            switch self {
            case .failed:
                return "Your transaction is failed"
            case .success:
                return "Your transaction has been successfully done."
            case .pending:
                return "Your transaction is pending"
            }
        }
    }
    var sendmoneyId: String = ""
    var sendAmount: String = ""
    var receiveAmount: String = ""
    var firstname: String = ""
    var lastname:String = ""
    var paymentStatus: PaymentStatus = .failed
    var message:String = ""
    var createdDate:String = ""
    var date:String = ""
    
    init() {
    }
    
    init(JsonDashBoard: JSON) {
        sendmoneyId = JsonDashBoard["sendmoneyId"].stringValue
        sendAmount = JsonDashBoard["sendAmount"].stringValue
        receiveAmount = JsonDashBoard["receiveAmount"].stringValue
        firstname = JsonDashBoard["firstname"].stringValue
        lastname = JsonDashBoard["lastname"].stringValue
        if let paymentStatusValue = PaymentStatus.init(rawValue: JsonDashBoard["payment_status"].stringValue.lowercased()) {
            paymentStatus = paymentStatusValue
        }
        message = JsonDashBoard["message"].stringValue
        createdDate = JsonDashBoard["created_date"].stringValue
        date = JsonDashBoard["date"].stringValue
    }
}
