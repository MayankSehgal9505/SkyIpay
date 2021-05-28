//
//  RecepientDetailsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit

class RecepientDetailsVC: UIViewController {

    private let user = UserData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let bankDetailsVC = BankDepositDetailVC()
        user.sendMoneyNavController!.pushViewController(bankDetailsVC, animated: false)
    }
}
