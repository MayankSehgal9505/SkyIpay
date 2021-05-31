//
//  URLNames.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
struct URLNames {
    static let baseUrl = "http://94.237.66.181/skpipay/api/"
    static let verifyOTP = "user/otp-verfiy"
    static let login = "user/login"
    static let countryList = "common/countries"
    static let getUserDetails = "user"
    static let register = "user/register"
    static let updateUserDetails = "user/update"
    static let uploadImage = "user/avatar"
    static let logout = "user/logout"
    static let faq = "common/faqs"
    static let enquiry = "user/enquiry"
    static let beneficiaryList = "user/beneficiary"
    static let addBeneficiary = "user/add-beneficiary"
    static let removeBeneficiary = "user/remove-beneficiary"
    static let bankList = "user/banks"
    static let receivePaymentMethodUrl = "user/receive-payment-method"
    static let transferReason = "user/transfer-reason"
}
