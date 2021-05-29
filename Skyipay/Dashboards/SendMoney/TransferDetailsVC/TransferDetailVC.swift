//
//  TransferDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
class TransferDetailVC: SendMoneySuperVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private let userInfo = UserData.sharedInstance

    @IBAction func contiueAction(_ sender: UIButton) {
        userInfo.selectedTab = .recipient
        subVCdelegate?.continueButtonTapped()
    }
}
