//
//  BeneficiaryTVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 05/05/21.
//

import UIKit

class BeneficiaryTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView!{didSet {
        baseView.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true,withCustomCornerRadius: 10.0)
        baseView.dropShadow(color: .gray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        }}
    @IBOutlet weak var beneficaryName: UILabel!
    @IBOutlet weak var beneficiaryImage: UIImageView!{didSet {
        beneficiaryImage.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: false)
        beneficiaryImage.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        }}
    @IBOutlet weak var beneficiaryStatus: UILabel!
    @IBOutlet weak var beneficiaryStatusImg: UIImageView!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var beneficiaryID: UILabel!
    @IBOutlet weak var beneficiaryBank: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ beneficiaryModel: BeneficiaryModel) {
        beneficaryName.text = beneficiaryModel.beneficiaryName.isEmpty ? "\(beneficiaryModel.beneficiaryFirstName + " " + beneficiaryModel.beneficiaryMiddleName + " " + beneficiaryModel.beneficiaryLastName)" : beneficiaryModel.beneficiaryName
        beneficiaryStatus.text = beneficiaryModel.beneficiaryStatus.beneficiaryStatusText
        beneficiaryStatusImg.image = UIImage.init(named: beneficiaryModel.beneficiaryStatus.beneficiaryStatusImg)
        accountNumber.text = "(AC \(beneficiaryModel.beneficiaryAccountNumber))"
        beneficiaryID.text = "ID: \(beneficiaryModel.beneficiaryID)"
        beneficiaryBank.text = beneficiaryModel.beneficiaryBankName
        
    }
}
