//
//  ReviewVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class ReviewVC: SendMoneySuperVC {
    @IBOutlet weak var transferDestinationValue: UILabel!
    @IBOutlet weak var transferAmountValue: UILabel!
    @IBOutlet weak var transferFeeValue: UILabel!
    @IBOutlet weak var transferTaxesValue: UILabel!
    @IBOutlet weak var transferTotalValue: UILabel!
    @IBOutlet weak var transferExchangeValue: UILabel!
    @IBOutlet weak var transferAmount2Value: UILabel!
    @IBOutlet weak var transferFee2Value: UILabel!
    @IBOutlet weak var totalRecipientAmountValue: UILabel!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var recipientLocation: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    //MARK:- Properties
    private let userInfo = UserData.sharedInstance
    private let sendMoneyInfo = SendMoney.sharedInstance
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(notification:)), name: Notification.Name("updateReviewData"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    //MARK:- Internal Methods
    @objc private func updateData(notification:Notification) {
        setupUI()
    }
    private func setupUI() {
        func setTransferSummaryUI() {
            transferDestinationValue.text = sendMoneyInfo.transferDetails.transferCountry.countryName
            transferAmountValue.text = sendMoneyInfo.transferDetails.transferAmout
            transferFeeValue.text = sendMoneyInfo.transferDetails.transferFee
            transferTaxesValue.text = sendMoneyInfo.transferDetails.transferTax
            
            transferTotalValue.text = "\(Float(sendMoneyInfo.transferDetails.transferAmout)! + Float(sendMoneyInfo.transferDetails.transferFee)!)"
            //transferExchangeValue.text = ""
            //transferAmount2Value.text = ""
            //transferFee2Value.text = ""
            //totalRecipientAmountValue.text = ""
        }
        func setOtherDetailsUI() {
            recipientName.text = "\(sendMoneyInfo.recipientDetails.recipientFirstName) \(sendMoneyInfo.recipientDetails.recipientSurName)"
            recipientLocation.text = sendMoneyInfo.recipientDetails.recipientCountry.countryName
            
            bankName.text = sendMoneyInfo.bankDepositDetails.bank.bankName
            accountNumber.text = sendMoneyInfo.bankDepositDetails.secureBankAccountNum
        }
        
        setTransferSummaryUI()
        setOtherDetailsUI()
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
