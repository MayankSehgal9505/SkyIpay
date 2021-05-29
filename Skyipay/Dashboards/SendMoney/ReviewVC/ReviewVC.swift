//
//  ReviewVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class ReviewVC: SendMoneySuperVC {
    private let userInfo = UserData.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func termsAndConditionCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func continueAction(_ sender: UIButton) {
        //userInfo.sendMoneyNavController!.popToRootViewController(animated: false)
    }
    
}
