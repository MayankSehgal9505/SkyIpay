//
//  ActivityTVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 22/04/21.
//

import UIKit

class ActivityTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView! {
        didSet {
            baseView.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
            baseView.dropShadow(color: .gray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var moneySent: UILabel!
    @IBOutlet weak var transactionMsg: UILabel!
    @IBOutlet var transactionStatusImgs: [UIImageView]!
    @IBOutlet weak var trrannsactonStatus: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(activityModel:ActivtyModel){
        self.userName.text = activityModel.firstname + " " + activityModel.lastname
        self.moneySent.text = activityModel.sendAmount
        transactionStatusImgs.forEach { $0.image = activityModel.paymentStatus.paymentStatusImage }
        self.transactionMsg.text = activityModel.paymentStatus.paymentStatusMsg
        self.trrannsactonStatus.text = activityModel.paymentStatus.paymentStatusText.0
        self.trrannsactonStatus.textColor = activityModel.paymentStatus.paymentStatusText.1
        self.datelbl.text = convertDateFormater(activityModel.date)
    }
    
    func convertDateFormater(_ date: String) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return  dateFormatter.string(from: date!)

        }
}
