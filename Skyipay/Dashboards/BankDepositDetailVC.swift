//
//  BankDepositDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class BankDepositDetailVC: UIViewController {

    private let user = UserData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let additionalDetailsVC = AdditionalDetailVC()
        user.sendMoneyNavController!.pushViewController(additionalDetailsVC, animated: false)
    }
}
