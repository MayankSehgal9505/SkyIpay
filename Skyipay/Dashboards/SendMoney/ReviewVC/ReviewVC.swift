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
    
    //MARK:- IBActions
    @IBAction func transferDetailBtnAction(_ sender: UIButton) {
        userInfo.selectedTab = .transfer
        subVCdelegate?.continueButtonTapped()
    }
    @IBAction func recipientDetailBtnAction(_ sender: UIButton) {
        userInfo.selectedTab = .recipient
        subVCdelegate?.continueButtonTapped()
    }
    
    @IBAction func bankDetailsBtnAction(_ sender: UIButton) {
        userInfo.selectedTab = .bankDeposit
        subVCdelegate?.continueButtonTapped()
    }
    @IBAction func paymentDetailBtnAction(_ sender: UIButton) {
        userInfo.selectedTab = .paymment
        subVCdelegate?.continueButtonTapped()
    }
    
    @IBAction func termsAndConditionCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        userInfo.selectedTab = .reset
        subVCdelegate?.continueButtonTapped()
    }
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.makeToast("Coming Soon", duration: 3.0, position: .center)
    }
}
