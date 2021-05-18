//
//  SideMenu.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit
typealias menuItem = (itemName:String, itemImage:String)
import Kingfisher
class SideMenu: UIViewController,LogOutCall {
    //MARK:- Enums
    enum RowType: Int, CaseIterable {
        case sendMoney = 0
        case transactions, beneficiaries, notifications, enquiry,shareApp, helpSupport,faq,logout
        
        var rowItems: menuItem {
            switch self {
            case .sendMoney: return ("Send Money","sendMoney")
            case .transactions: return ("Transactions","transactions")
            case .beneficiaries: return ("My Beneficiary","myBeneficary")
            case .notifications: return ("Notifications","Notifications")
            case .enquiry: return ("Enquiry","Enquiry")
            case .shareApp: return ("Share App","shareApp")
            case .helpSupport: return ("Help & Support","help&Support")
            case .faq: return ("FAQ","FAQ")
            case .logout: return ("Logout","logout")
            }
        }
    }
    //MARK:- IBOUtlets
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.makeCircularView(withBorderColor: .white, withBorderWidth: 5.0)
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var appVersionLbl: UILabel!
    
    //MARK:- Local Variables
    private let user = UserData.sharedInstance

    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLbl.text = "v\(appVersion)"
            appVersionLbl.isHidden = false
        } else {
            appVersionLbl.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccepted(notification:)), name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)
    }

    @objc func updateAccepted(notification: Notification) {
        setupUserUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUserUI()
    }
    //MARK:- Internal Methods
    private func setupUserUI() {
        userName.text = user.userModel.userName
        if let imageURL = URL.init(string: user.userModel.userImageUrl) {
            userImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "UserProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            userImage.image = UIImage(named: "UserProfile")
        }
    }
    
    private func logout() {
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let logoutButton = UIAlertAction(title: "Logout", style: .default) { _ in
            self.callLogOutApi()
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        logOutAlert.addAction(logoutButton)
        logOutAlert.addAction(cancelButton)
        self.present(logOutAlert, animated: true, completion: nil)
    }
    /// setup tableView
    private func setupTableView() {
        menuTableView.register(UINib.init(nibName: "SideMenuTVC", bundle: nil), forCellReuseIdentifier: "SideMenuTVC")
        menuTableView.estimatedRowHeight = 80
        menuTableView.rowHeight = UITableView.automaticDimension
        menuTableView.tableFooterView = UIView()
    }
    
    private func moveToBeneficiaryVC() {
        let beneficiariesVC = BeneficiariesVC()
        user.rootVC = (Utility.appDelegate.window?.rootViewController)!
        let navigationController = UINavigationController.init(rootViewController: beneficiariesVC)
        Utility.appDelegate.window?.rootViewController = navigationController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func moveToFAQVC() {
        let faqVC = FAQVC()
        user.rootVC = (Utility.appDelegate.window?.rootViewController)!
        let navigationController = UINavigationController.init(rootViewController: faqVC)
        Utility.appDelegate.window?.rootViewController = navigationController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func moveToEnquiryVC() {
        let enquiryVC = EnquiryVC()
        user.rootVC = (Utility.appDelegate.window?.rootViewController)!
        let navigationController = UINavigationController.init(rootViewController: enquiryVC)
        Utility.appDelegate.window?.rootViewController = navigationController
        self.present(navigationController, animated: true, completion: nil)
    }
    //MARK:- IBActions

    @IBAction func userProfileBtnTapped(_ sender: UIButton) {
        let updateProfile = UserProfileVC()
        user.rootVC = (Utility.appDelegate.window?.rootViewController)!
        let navigationController = UINavigationController.init(rootViewController: updateProfile)
        Utility.appDelegate.window?.rootViewController = navigationController
        self.present(navigationController, animated: true, completion: nil)
    }
}

//MARK:- UITableViewDataSource Methods

extension SideMenu: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        guard let rowType = RowType.init(rawValue: indexPath.row) else {return itemCell}
        itemCell.setupCell(menuItem: rowType.rowItems)
        return itemCell
    }
}

//MARK:- UITableViewDelegate Methods

extension SideMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = RowType.init(rawValue: indexPath.row) else {return }
        switch rowType {
            case .sendMoney:
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 2
                    self.sideMenuViewController.hideViewController()
                }
            case .transactions:
            break
            case .beneficiaries:
            break
            case .notifications:
            break
            case .enquiry:
                DispatchQueue.main.async {
                    self.moveToEnquiryVC()
                    self.sideMenuViewController.hideViewController()
                }
            case .shareApp:
            break
            case .helpSupport:
            break
            case .faq:
                DispatchQueue.main.async {
                    self.moveToFAQVC()
                    self.sideMenuViewController.hideViewController()
                }
            case .logout:
            logout()
        }
    }
}
    
//MARK:- API call Methods

extension SideMenu {
    private func logoutApiCall() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let verifyOTPURL = URLNames.baseUrl + URLNames.verifyOTP
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: verifyOTPURL, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                Defaults.resetDefaults()
                Utility.loginRootVC()
                self.dismissHUD(isAnimated: true)
         })
     }else{
        Defaults.resetDefaults()
        Utility.loginRootVC()
     }
        
    }
}
