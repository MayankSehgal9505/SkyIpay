//
//  WalkthroughCell.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 17/04/21.
//

import UIKit

class WalkthroughCell: UICollectionViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var walkThroughImage: UIImageView!
    @IBOutlet weak var walkThroughtTitle: UILabel!
    @IBOutlet weak var walkthroughDescription: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    //MARK:- Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
    }
    //MARK:- Internal Methods
    func setupCell(walkthroughModel:WalkThroughModel) {
        walkThroughImage.image = UIImage(named: walkthroughModel.imageName)
        walkThroughtTitle.text = walkthroughModel.titleText
        walkthroughDescription.text = walkthroughModel.descriptionText
        layoutIfNeeded()
    }
}
