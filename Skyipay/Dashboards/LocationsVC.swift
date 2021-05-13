//
//  LocationsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class LocationsVC: BaseTabVC {
    
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
        setTitle(navigationTitle:"Locations")
        enableRightBtn()
    }
}
