//
//  ActivitesVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit

class ActivitesVC: BaseTabVC {
    //MARK:- IBOutlets

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var activityTBView: UITableView!
    @IBOutlet weak var noActivityLbl: UILabel!
    
    //MARK:- Local Variables
    private let user = UserData.sharedInstance
    var activityList = Array<ActivtyModel>()
    //private var activities
    //MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        self.view.makeToast("Coming Soon", duration: 3.0, position: .center)
        //getActvites()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityList.removeAll()
        activityTBView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Call the roundCorners() func right there.
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Internal Methods
    func setupNavigationBar() {
        setTitle(navigationTitle:"Activities")
        enableRightBtn()
    }
    /// setup tableView
    private func setupTableView() {
        activityTBView.register(UINib(nibName: "ActivityTVC", bundle: nil), forCellReuseIdentifier: "ActivityTVC")
        activityTBView.tableFooterView = UIView()
        activityTBView.estimatedRowHeight = 100
        activityTBView.rowHeight = UITableView.automaticDimension
    }
}
//MARK:- UITableViewDataSource Methods
extension ActivitesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTVC", for: indexPath) as! ActivityTVC
        activityCell.setupCell(activityModel:activityList[indexPath.row])
        return activityCell
    }
}

//MARK:- UITableViewDelegate Methods
extension ActivitesVC: UITableViewDelegate {
    
}

//MARK:- API Call Methods
/*extension ActivitesVC {
    func getActvites(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getActivityUrl = URLNames.baseUrl + URLNames.activityList
            let userID = !user.userModel.userID.isEmpty ? user.userModel.userID : Defaults.getUserID()
            let parameters = [
                "user_id":"80",
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: getActivityUrl, method: .post, parameters: parameters, completionHandler: {  (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let activies =  jsonValue[APIFields.dataKey]?.array {
                    for activity in activies {
                        let actvityModel = ActivtyModel.init(JsonDashBoard: activity)
                        self.activityList.append(actvityModel)
                    }
                    if self.activityList.count > 0 {
                        self.noActivityLbl.isHidden = true
                        self.activityTBView.isHidden = false
                        self.activityTBView.reloadData()
                    } else{
                        self.noActivityLbl.isHidden = false
                        self.activityTBView.isHidden = true
                    }
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
}*/
