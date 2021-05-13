//
//  RecipientsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class RecipientsVC: BaseTabVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        self.view.makeToast("Coming Soon", duration: 3.0, position: .center)
    }
    
    //MARK:- Internal Methods
    func setupNavigationBar() {
        setTitle(navigationTitle:"Recipients")
        enableRightBtn()
    }
}
