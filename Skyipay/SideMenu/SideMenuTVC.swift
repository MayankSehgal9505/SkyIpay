//
//  SideMenuTVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class SideMenuTVC: UITableViewCell {

    //MARK:- IBOutlets 
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    //MARK:- Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Internal Methods
    func setupCell(menuItem:menuItem) {
        itemImg.image = UIImage.init(named: menuItem.itemImage)
        itemName.text = menuItem.itemName
    }
    
}
