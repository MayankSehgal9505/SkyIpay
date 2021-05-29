//
//  RecepientDetailsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
class RecepientDetailsVC: SendMoneySuperVC {
    private let userInfo = UserData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        userInfo.selectedTab = .bankDeposit
        subVCdelegate?.continueButtonTapped()
    }
}
