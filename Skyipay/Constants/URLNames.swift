//
//  URLNames.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
struct URLNames {
    static let baseUrl = "http://dev.equalinfotech.in/skyipay/api/"
    static let verifyOTP = "user/otp-verfiy"
    static let login = "user/login"
    static let countryList = "common/countries"
    static let getUserDetails = "user/getuserdetail"
    static let register = "user/register"
    static let updateUserDetails = "user/update"
    //http://dev.equalinfotech.in/skyipay/api/user/userdetailupdate
    static let uploadImage = "user/avatar"
    static let logout = "user/logout"
    static let faq = "common/faqs"
    static let enquiry = "user/enquiry"
    static let beneficiaryList = "user/receipientlist"
    static let beneficiaryDetails = "user/receipientdetailbyid"
    static let addBeneficiary = "user/add-beneficiary"
    static let removeBeneficiary = "user/remove-beneficiary"
    static let bankList = "user/banks"
    static let receivePaymentMethodUrl = "user/receive-payment-method"
    static let transferReason = "user/transfer-reason"
    static let getFee = "user/app-fee"
    static let currencyConverter = "user/currency-converters"
    static let occupationList = "user/occupationlist"
    static let idDocuments = "user/id-documents"
    static let transferFee = "user/transactionfee"
}
