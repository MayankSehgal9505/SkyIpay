//
//  BankDepositDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class BankDepositDetailVC: SendMoneySuperVC {

    private let userInfo = UserData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        userInfo.selectedTab = .additional
        subVCdelegate?.continueButtonTapped()

    }
}
