//
//  BeneficiaryDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 25/05/21.
//

import UIKit
import CountryPickerView
class BeneficiaryDetailVC: BaseViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var beneficiaryUserImg: UIImageView!{didSet {
        beneficiaryUserImg.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: false)
        beneficiaryUserImg.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        }}
    @IBOutlet weak var beneficiaryAccountStatusImg: UIImageView!
    @IBOutlet weak var beneficiaryAccountStatus: UILabel!
    @IBOutlet weak var beneficiaryID: UILabel!
    @IBOutlet weak var beneficiaryName: UILabel!
    @IBOutlet weak var beneficiaryBankName: UILabel!
    @IBOutlet weak var beneficiaryAccountNum: UILabel!
    @IBOutlet weak var beneficiaryMobileNum: UILabel!
    @IBOutlet weak var beneficiaryEmail: UILabel!
    @IBOutlet weak var benneficiaryDob: UILabel!
    @IBOutlet weak var beneficiaryCountry: UILabel!
    
    //MARK:- Local Variables
    var beneficiaryModel = BeneficiaryModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Internal Methods
    private func setUpUI(){
        self.setTitle(navigationTitle: "My Beneficiary")
        enableLeftBtn(withIcon: "leftArrow")
        setupBeneficiaryData()
    }
    
    private func setupBeneficiaryData() {
        beneficiaryAccountStatusImg.image = UIImage.init(named: beneficiaryModel.beneficiaryStatus.beneficiaryStatusImg)
        beneficiaryAccountStatus.text = beneficiaryModel.beneficiaryStatus.beneficiaryStatusText
        beneficiaryID.text = "ID: \(beneficiaryModel.beneficiaryID)"
        beneficiaryName.text = beneficiaryModel.beneficiaryName
        beneficiaryBankName.text = beneficiaryModel.beneficiaryBankName
        beneficiaryAccountNum.text = "(AC \(beneficiaryModel.beneficiaryAccountNumber))"
        beneficiaryMobileNum.text = "+ \(beneficiaryModel.beneficiaryDialCode) \(beneficiaryModel.beneficiaryPhoneNumber)"
        beneficiaryEmail.text = beneficiaryModel.beneficiaryEmail
        benneficiaryDob.text = beneficiaryModel.beneficiaryDOB
        beneficiaryCountry.text = beneficiaryModel.countryModel.countryName
    }
    
    //MARK:- IBActions
    override func leftButtonAction() {
        self.navigationController?.popViewController(animated: false)
    }
}
