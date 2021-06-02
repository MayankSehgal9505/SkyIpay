//
//  BankDepositModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
import SwiftyJSON
struct BankDeposit {
    //MARK: Variable
    var bank = Bank()
    var bankAccountNum = ""
    var secureBankAccountNum:String {
        get {
            var secureData = ""
            let chars = Array(bankAccountNum)     // gets an array of characters
            for (index,_) in chars.enumerated() {
                if index <= chars.count/2 {
                    secureData += "*"
                } else {
                    secureData += String(chars[index])
                }
            }
            return secureData
        }
    }
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
    }
}


