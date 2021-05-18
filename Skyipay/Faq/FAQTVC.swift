//
//  FAQTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 17/05/21.
//

import UIKit

class FAQTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var faqQuesLbl: UILabel!
    @IBOutlet weak var faqAnswerLbl: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var viewAnswerBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(faqModel:FAQModel) {
        baseView.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
        baseView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
        faqQuesLbl.text = faqModel.faqQues
        faqAnswerLbl.text = faqModel.faqAnswer
        viewAnswerBtn.isSelected = faqModel.faqAnswerVisible
        answerView.isHidden = !faqModel.faqAnswerVisible
    }
}
