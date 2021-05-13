//
//  VerificationDoneVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 23/04/21.
//

import UIKit

class VerificationDoneVC: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK:- IBActions

    @IBAction func loginNowBtnTapped(_ sender: UIButton) {
        Utility.loginRootVC()
    }
    
}
