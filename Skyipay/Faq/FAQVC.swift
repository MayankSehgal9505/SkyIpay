//
//  FAQVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit
import RESideMenu

class FAQVC: BaseViewController {

    //MARK:- IBOutles
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var faqTBView: UITableView!
    //MARK:- Local Variables
    private var faqs = [FAQModel]()
    private let user = UserData.sharedInstance
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getFaqsList()
        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func setUpUI() {
        self.setTitle(navigationTitle: "FAQ's")
        enableLeftBtn(withIcon: "leftArrow")
        setUpTBView()
    }

    private func setUpTBView(){
        /// Register Cells
        faqTBView.register(UINib(nibName: "FAQTVC", bundle: nil), forCellReuseIdentifier: "FAQTVC")
        faqTBView.tableFooterView = UIView()
        faqTBView.estimatedRowHeight = 150
        faqTBView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- IBActions
    override func leftButtonAction() {
        Utility.appDelegate.window?.rootViewController = user.rootVC
    }
}

//MARK:- API Calls
extension FAQVC {
    func getFaqsList() {        
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = URLNames.baseUrl + URLNames.faq
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let faqslist = jsonValue[APIFields.dataKey]?.array {
                        var faqs = Array<FAQModel>()
                        for faq in faqslist {
                            let faqModel = FAQModel.init(json: faq)
                            faqs.append(faqModel)
                        }
                        self.faqs = faqs
                    }
                    DispatchQueue.main.async {
                        self.faqTBView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}


//MARK:- UITableViewDataSource & UITableViewDelegate Methods
extension FAQVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTVC", for: indexPath) as! FAQTVC
        cell.setupCell(faqModel: faqs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < faqs.count {
            faqs[indexPath.row].faqAnswerVisible = !faqs[indexPath.row].faqAnswerVisible
            faqTBView.beginUpdates()
            faqTBView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
            faqTBView.endUpdates()
        }
    }
}
