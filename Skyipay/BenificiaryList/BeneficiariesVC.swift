//
//  BeneficiariesVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 05/05/21.
//

import UIKit

class BeneficiariesVC: BaseViewController {
    //MARK:- enums
    //MARK:- IBOutlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var beneficiariesTBView: UITableView!
    //MARK:- Local Variables
    private let user = UserData.sharedInstance
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
        self.setTitle(navigationTitle: "Beneficiaries")
        enableLeftBtn(withIcon: "leftArrow")
        setupTableView()
    }
    
    private func setupTableView() {
        beneficiariesTBView.register(UINib.init(nibName: "BeneficiaryTVC", bundle: nil), forCellReuseIdentifier: "BeneficiaryTVC")
        beneficiariesTBView.tableFooterView = UIView()
        beneficiariesTBView.estimatedRowHeight = 80
        beneficiariesTBView.rowHeight = UITableView.automaticDimension
        beneficiariesTBView.dataSource = self
        beneficiariesTBView.delegate = self
    }

    //MARK:- IBActions
    override func leftButtonAction() {
        Utility.appDelegate.window?.rootViewController = user.rootVC
    }
}

// MARK: API Call
extension BeneficiariesVC {
    
}

// MARK: API Call
extension BeneficiariesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeneficiaryTVC", for: indexPath) as! BeneficiaryTVC
        cell.setupCell()
        return cell
    } 
}

// MARK: API Call
extension BeneficiariesVC: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
