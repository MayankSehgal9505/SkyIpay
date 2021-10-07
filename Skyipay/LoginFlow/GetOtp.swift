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
}

extension GetOtp where Self:UIViewController {
    func callLoginAPI(userModelObj:UserModel,completionHandler:@escaping ()->Void){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = URLNames.baseUrl + URLNames.login
            let parameters = [
                "dial_code":"\(userModelObj.userAddress.first?.countryModel.countryDialCode ?? 0)",
                "iso":userModelObj.userAddress.first?.countryModel.countryISOCode ?? "",
                "phone":userModelObj.userPhoneNumber,
                "device_id":Defaults.getDeviceToken(),
                "status":"login"
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             print(jsonValue)
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                completionHandler()
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
}
