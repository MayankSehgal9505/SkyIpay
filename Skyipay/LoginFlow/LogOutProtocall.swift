//
//  LogOutProtocall.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 15/05/21.
//

import Foundation
import UIKit
protocol LogOutCall: class  {
}

extension LogOutCall where Self:UIViewController {
    func callLogOutApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let logoutUrl = URLNames.baseUrl + URLNames.logout
            let headers = [     "Authorization": "Bearer \(Defaults.getAccessToken())"      ]
            NetworkManager.sharedInstance.commonApiCall(url: logoutUrl, method: .get, parameters: nil, headers: headers,completionHandler: { (json, status) in
                Defaults.resetDefaults()
                Utility.loginRootVC()
                self.dismissHUD(isAnimated: true)
             })
     } else{
         self.showNoInternetAlert()
     }
    }
}
