//
//  APIFields.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation

struct APIFields {
    static let successKey = "success"
    static let dataKey = "data"
    static let msgKey = "msg"
    static let codeKey = "code"
    static let accessTokenKey = "access_token"

    
}

enum DeviceType : String {
    case ios = "2"
    case android = "1"
}
