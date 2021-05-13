//
//  SideMenu.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit
typealias menuItem = (itemName:String, itemImage:String)
class SideMenu: UIViewController {

    //MARK:- IBOUtlets
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.makeCircularView(withBorderColor: .white, withBorderWidth: 5.0)
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    //MARK:- Local Variables
    private var menuItems:[menuItem] = [("Send Money","sendMoney"),("Transactions","transactions"),("My Beneficiary","myBeneficary"),("Notifications","Notifications"),("Enquiry","Enquiry"),("Share App","shareApp"),("Help & Support","help&Support"),("FAQ","FAQ"),("Logout","")]
    private let user = UserData.sharedInstance

    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        userName.text = "\(user.userModel.firstName) \(user.userModel.lastname)"
    }
    
    private func logout() {
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let logoutButton = UIAlertAction(title: "Logout", style: .default) { _ in
            Defaults.resetDefaults()
            Utility.loginRootVC()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        itemCell.setupCell(menuItem: menuItems[indexPath.row])
        return itemCell
    }
}

//MARK:- UITableViewDelegate Methods

extension SideMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 2
                self.sideMenuViewController.hideViewController()
            }
        case 2:
            DispatchQueue.main.async {
                self.moveToBeneficiaryVC()
                self.sideMenuViewController.hideViewController()
            }
        case 1,3..<menuItems.count-1:
            self.view.makeToast("Coming soon", duration: 1.0, position: .center)
            DispatchQueue.main.async {
                self.sideMenuViewController.hideViewController()
            }
        default:
            logout()
        }
    }
}
