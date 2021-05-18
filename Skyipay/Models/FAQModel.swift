//
//  FAQModel.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/05/21.
//

import Foundation
import SwiftyJSON

struct FAQModel {
    //MARK: Variable
    var faqID = ""
    var faqQues = ""
    var faqAnswer = ""
    var faqAnswerVisible = false
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.faqID = json["id"].stringValue
        self.faqQues = json["question"].stringValue
        self.faqAnswer = json["answer"].stringValue
    }
}
