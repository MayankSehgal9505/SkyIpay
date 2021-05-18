//
//  Constants.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 16/04/21.
//

import Foundation
struct AlertField {
    static let okString = "OK"
    static let noInternetString = "No Internet found"
    static let oopsString = "Ooops!"
    static let alertString = "Alert!"
    static let loaderString = "Loading"
    static let numberEmpty = "Please entter phone number"
    static let invalidNumber = "Phone number must be of 10 digits"
}
struct WalkthroughUI {
    static let walkthroughImages = ["walkthroughImage1","walkthroughImage2","walkthroughImage3","walkthroughImage4","walkthroughImage5"]
    static let titleTexts = ["Absolute Safety", "Various Services", "Easy Deposit and Withdrawal","Quick money transfer", "Attractive deals"]
    static let descriptionTexts = ["Multi-storey security international standard", "Consumer Loan Payment, Pay bills andd many other services","Diversify recharge and withdraw money, free recharge with bank account", "Send andd receive money quickly just need a phone number", "High discount, great promotion"]
}

struct LoginRegisterUI {
    static let registerMsg = "Don't have account yet?"
    static let registerBtnTitle = "Register"
    static let loginMsg = "Already have account?"
    static let loginBtnTitle = "Login"
}

struct ValidateOTPUI {
    static let validateOTPMsg = "A verification code has been sent to %@"
    static let resendOTPWithTime = "Send Again OTP (%@s)"
    static let resendOTPWithOutTime = "Send Again OTP"
}


struct Common {
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let genderArray = ["Male", "Female", "Other"]
}

struct EnquiyVC {
    static let messsagePlaceHolder = "Please write your message here"
    static let enquirySuccessfull = "Enquiry sent successfully"
}
