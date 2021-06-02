//
//  SendMoney.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
final class SendMoney: NSObject {
    static let sharedInstance = SendMoney()

    //Send Money Properties
    var transferDetails = TransferDetails()
    var recipientDetails = RecipientDetail()
    var bankDepositDetails = BankDeposit()
    private override init() { }
}
