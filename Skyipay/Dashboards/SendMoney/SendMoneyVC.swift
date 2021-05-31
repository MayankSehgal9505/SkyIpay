//
//  SendMoneyVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit
import CountryPickerView

class SendMoneyVC: BaseTabVC {
    //MARK:- Enums
    enum PickerType {
        case moneyObtainOptions
        case bankOptions
    }
    
    //MARK:- IBOutlets
    @IBOutlet weak var sendMoneyTabView: SendMoneyTabView!
    @IBOutlet weak var sendMoneyContainerView: UIView!
    @IBOutlet weak var logoView: UIView! {
        didSet {
            logoView.makeCircularView(withBorderColor: .lightGray, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 5)
        }
    }
    @IBOutlet weak var baseView: UIView!{
        didSet {
            baseView.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
            baseView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        }
    }
    //MARK:- Local Variables
    private let userInfo = UserData.sharedInstance
    lazy var transferDetailVC: TransferDetailVC = TransferDetailVC()
    lazy var recepientDetailVC: RecepientDetailsVC = RecepientDetailsVC()
    lazy var bankDetailVC: BankDepositDetailVC = BankDepositDetailVC()
    lazy var additionalDetailVC: AdditionalDetailVC = AdditionalDetailVC()
    lazy var paymentDetailVC: PaymentDetailVC = PaymentDetailVC()
    lazy var reviewVC: ReviewVC = ReviewVC()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        sendMoneyTabView.tabDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //getUserDetails()
        setupUI()
    }
    
    //MARK:- Internal Methods
    private func setupContainerView() {
        var senMoneySuperVC = SendMoneySuperVC()
        if let cachedClass = userInfo.cachedControllers.filter({ (controllerDict) -> Bool in
            return controllerDict.keys.contains(userInfo.selectedTab.associatedClass)
        }).first {
            senMoneySuperVC = cachedClass[userInfo.selectedTab.associatedClass] as! SendMoneySuperVC
        } else {
            let myclass = Utility.classFromString(userInfo.selectedTab.associatedClass) as! SendMoneySuperVC.Type
            senMoneySuperVC = myclass.init()
            sendMoneyTabView.updateUI()

        }
        senMoneySuperVC.subVCdelegate = self
        ViewEmbedder.embed(parent: self, container: sendMoneyContainerView, child: senMoneySuperVC, childClassName: userInfo.selectedTab.associatedClass, previous: transferDetailVC)
    }
    private func setupUI(){
        setupNavigationBar()
    }

    func setupNavigationBar() {
        setTitle(navigationTitle:"Send Money")
        self.enableRightBtn()
    }
    /// Function to be called to enable right bar button item
    /// - Parameter imageName: name of image to be used as button icon
    @objc override func enableRightBtn() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        //Adding Right bar button
        let firstRightBarButtonItem = UIBarButtonItem(image: UIImage(named: "UserProfile"), style: .plain, target: self, action: #selector(userProfileBtnAction))
        firstRightBarButtonItem.tintColor = UIColor.white
        let secondRightBarButtonItem = UIBarButtonItem(image: UIImage(named: "notification"), style: .plain, target: self, action: #selector(notificationAction))
        secondRightBarButtonItem.tintColor = UIColor.white
        self.tabBarController?.navigationItem.rightBarButtonItems = [firstRightBarButtonItem,secondRightBarButtonItem]
    }
    
    @objc private func userProfileBtnAction() {
        let updateProfile = UserProfileVC()
        updateProfile.screenOpendBy = .pushed
        self.navigationController?.pushViewController(updateProfile, animated: true)
    }
    
    @objc private func notificationAction() {
        
    }
}
//MARK:- SendMoneySuperVCNavigator Delegate Methods
extension SendMoneyVC:SendMoneySuperVCNavigator {
    func continueButtonTapped() {
        switch userInfo.selectedTab {
        case .reset:
            userInfo.cachedControllers.removeAll()
            sendMoneyTabView.resetUI()
            userInfo.selectedTab = .transfer
            setupContainerView()
        default:
            setupContainerView()
        }
    }
}
//MARK:- SendMoneySuperVCNavigator Delegate Methods

extension SendMoneyVC:SendMoneyTabProtocol {
    func tabBtnTapped() {
        setupContainerView()
    }
}

//MARK:- API Call
extension SendMoneyVC {
    func getUserDetails(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getUserDetails : String = URLNames.baseUrl + URLNames.getUserDetails
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: getUserDetails, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.dataKey]!)
                    self.userInfo.userModel = userModel
                    switch userModel.userVerified {
                    case .ongoing:
                        Utility.VerificationPendingRootVC()
                    case .verified: break
                    case .failed:
                        Utility.loginRootVC()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserInfo"), object: self)
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
}


