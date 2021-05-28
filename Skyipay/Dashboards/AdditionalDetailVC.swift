//
//  AdditionalDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class AdditionalDetailVC: UIViewController {

    @IBOutlet weak var continueBtn: CustomButton!{
        didSet {
            continueBtn.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        }
    }
    private let user = UserData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func continueAction(_ sender: UIButton) {
        let paymentDetailsVC = PaymentDetailVC()
        user.sendMoneyNavController!.pushViewController(paymentDetailsVC, animated: false)
    }
}
