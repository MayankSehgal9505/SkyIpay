//
//  RecipientsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class RecipientsVC: BaseTabVC {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var beneficiaryTBView: UITableView!
    @IBOutlet weak var noBeneficiaryLbl: UILabel!

    private let user = UserData.sharedInstance
    private var beneficiaries = [BeneficiaryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        getBeneficiariesList()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func setupView() {
        setupNavigationBar()
        setupTableView()

    }
    func setupNavigationBar() {
        setTitle(navigationTitle:"Recipients")
        enableRightBtn()
    }
    private func setupTableView() {
        beneficiaryTBView.register(UINib.init(nibName: "BeneficiaryTVC", bundle: nil), forCellReuseIdentifier: "BeneficiaryTVC")
        beneficiaryTBView.tableFooterView = UIView()
        beneficiaryTBView.estimatedRowHeight = 80
        beneficiaryTBView.rowHeight = UITableView.automaticDimension
        beneficiaryTBView.dataSource = self
        beneficiaryTBView.delegate = self
    }
    @IBAction func addBeneficiaryBtn(_ sender: UIButton) {
    }
}

// MARK: API Call
extension RecipientsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beneficiaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeneficiaryTVC", for: indexPath) as! BeneficiaryTVC
        cell.setupCell(beneficiaries[indexPath.row])
        return cell
    }
}

// MARK: API Call
extension RecipientsVC: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beneficiaryDetailVC = BeneficiaryDetailVC()
        beneficiaryDetailVC.beneficiaryModel = beneficiaries[indexPath.row]
        self.navigationController?.pushViewController(beneficiaryDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
            // Write action code for the Deleting beneficiary
        let trashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.removeBeneficiary(beneficiaryModel: self.beneficiaries[indexPath.row])
            success(true)
        })
        trashAction.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [trashAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// MARK: API Call
extension RecipientsVC {
    private func removeBeneficiary(beneficiaryModel:BeneficiaryModel) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let updateUserProfileUrl = URLNames.baseUrl + URLNames.removeBeneficiary
            let parameters = [
                "id":beneficiaryModel.beneficiaryID,
            ] as [String : Any]
            print(parameters)
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: updateUserProfileUrl, method: .post, parameters: parameters,headers: headers, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                 if let _ =  jsonValue[APIFields.dataKey]?.array {
                    self.getBeneficiariesList()
               }
             }
             else {
                 self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
             }
             self.dismissHUD(isAnimated: true)
         })
     }else{
         self.showNoInternetAlert()
     }
    }

    private func getBeneficiariesList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = URLNames.baseUrl + URLNames.beneficiaryList
            print(faqURL)
            //http://dev.equalinfotech.in/skyipay/api/user/receipientlist
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            let params = [
                "user_id": "\(String(describing: Defaults.getUserID()!))",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .post, parameters: params,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let beneficiarylist = jsonValue[APIFields.dataKey]?.array {
                        var beneficiaries = Array<BeneficiaryModel>()
                        for beneficiary in beneficiarylist {
                            let beneficiaryModel = BeneficiaryModel.init(json: beneficiary)
                            beneficiaries.append(beneficiaryModel)
                        }
                        self.beneficiaries = beneficiaries
                    }
                    DispatchQueue.main.async {
                        self.beneficiaryTBView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.beneficiaryTBView.isHidden = self.beneficiaries.count == 0
                    self.noBeneficiaryLbl.isHidden = !self.beneficiaryTBView.isHidden
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}
