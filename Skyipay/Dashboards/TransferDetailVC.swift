//
//  TransferDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
protocol TransferDetailProtocol: class {
    func continueTapped()
}
class TransferDetailVC: UIViewController {

    var transferDetailDelegate: TransferDetailProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private let user = UserData.sharedInstance

    @IBAction func contiueAction(_ sender: UIButton) {
        let recipientDetailVC = RecepientDetailsVC()
        user.sendMoneyNavController!.pushViewController(recipientDetailVC, animated: false)
    }
}
