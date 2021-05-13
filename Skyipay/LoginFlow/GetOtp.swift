//
//  GetOtp.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
import UIKit
import SwiftyJSON
protocol GetOtp: class  {
    associatedtype screenType
}

extension GetOtp where Self:UIViewController {
    func callLoginAPI(screenType:ScreenType,countryCode:String, phoneNumber: String,completionHandler:@escaping (UserModel)->Void){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = URLNames.baseUrl + URLNames.loginWithNumber
            let parameters = [
                "countryCode":countryCode,
                "phoneNumber":phoneNumber,
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             print(jsonValue)
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let _ =  jsonValue[APIFields.msgKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.msgKey]!)
                    completionHandler(userModel)
               }
             }
             else {
                self.view.makeToast(jsonValue[APIFields.msgKey]?["message"].stringValue, duration: 3.0, position: .bottom)

             }
             self.dismissHUD(isAnimated: true)
         })
     }else{
         self.showNoInternetAlert()
     }
    }
    
    func registerAPI(screenType:ScreenType,countryCode:String, phoneNumber: String,completionHandler:@escaping (UserModel)->Void) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = URLNames.baseUrl + URLNames.sendOTPRegister
            let parameters = [
                "countryCode":countryCode,
                "phoneNumber":phoneNumber,
            ] as [String : Any]
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.dismissHUD(isAnimated: true)
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                return
             }
             print(jsonValue)
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let responseDic =  jsonValue[APIFields.msgKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.msgKey]!)
                    completionHandler(userModel)
                 }
             }
             else {
                 self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)

             }
             self.dismissHUD(isAnimated: true)
         })
     }else{
         self.showNoInternetAlert()
     }
 }
}
