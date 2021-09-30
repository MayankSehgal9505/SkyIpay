//
//  Occupation.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 30/09/21.
//

import Foundation
import SwiftyJSON
struct Occupation {
    //MARK: Variable
    var id = 0
    var occupationTitle = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.id = json["id"].intValue
        self.occupationTitle = json["title"].stringValue
    }
}
