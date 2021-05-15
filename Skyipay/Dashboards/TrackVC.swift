//
//  TrackVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class TrackVC: BaseTabVC {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var orderTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        self.view.makeToast("Coming Soon", duration: 3.0, position: .center)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Call the roundCorners() func right there.
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Internal Methods
    func setupNavigationBar() {
        setTitle(navigationTitle:"Tracking")
        enableRightBtn()
    }
    @IBAction func trackTransferBtnAction(_ sender: UIButton) {
        if (self.orderTxtFld.text?.isEmpty ?? true) {
            self.view.makeToast("Order Number can't be empty", duration: 3.0, position: .bottom)
        } else {
            self.view.makeToast("Coming Soon", duration: 3.0, position: .center)
        }
    }
}

