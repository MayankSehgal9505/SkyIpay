//
//  NetworkManager.swift
//  Equal Infotech
//  Created by Equal Infotech on 14/06/19.
//  Copyright © 2019 Equal Infotech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Class for making Api calls
public class NetworkManager {
    
    //MARK: Variable declaration
    static let sharedInstance = NetworkManager()
    
    //MARK:- Check Internet Connectivity
    func isInternetAvailable() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK:- Common Network Service Call
    func commonApiCall(url:String,method:HTTPMethod,parameters : [String:Any]?, headers: HTTPHeaders? = nil ,completionHandler:@escaping (JSON?,String?)->Void) {
        Alamofire.request(URL.init(string: url)!, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.value{
                    let json = JSON(data)
                    print(json)
                    completionHandler(json,nil)
                    return
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error.localizedDescription)
                break
            }
        }
    }
    
    func uploadDocuments(url:String,method:HTTPMethod,imagesDict:[String:Data],parameters : [String:Any]?,headers: HTTPHeaders? = nil,completionHandler:@escaping (JSON?,String?)->Void) {
          Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let params = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
                
            for (key, value) in imagesDict {
                multipartFormData.append(value, withName: "\(key)", fileName: "\(key).jpg", mimeType: "image/jpg")
            }
          }, usingThreshold: UInt64.init(), to: url, method: .post,headers: headers) { (result) in
              switch result{
              case .success(let upload, _, _):
                  upload.responseJSON { response in
                      print("Succesfully uploaded  = \(response)")
                      if let err = response.error{
                        completionHandler(nil,err.localizedDescription)
                          print(err)
                          return
                      }
                    if let data = response.value{
                        let json = JSON(data)
                        completionHandler(json,nil)
                        return
                    }
                  }
              case .failure(let error):
                completionHandler(nil,error.localizedDescription)
              }
          }

  }

}
//Class ends here
