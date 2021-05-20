//
//  SendMoneyVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit
import CountryPickerView

class SendMoneyVC: BaseTabVC {
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
    //UITextfields
    @IBOutlet weak var countryTxtfld: UITextField!
    @IBOutlet weak var sendAmountTxtFld: UITextField!
    @IBOutlet weak var currenyCountryLbl: UILabel!
    @IBOutlet weak var recepientAmountTxtFld: UITextField!
    @IBOutlet weak var recepientGetMoneyTxtFld: UITextField!
    @IBOutlet weak var senderSendMoneyTxtFld: UITextField!
    @IBOutlet weak var bankNameTxtFld: UITextField!
    @IBOutlet weak var countryCurrenyView: UIView!{
        didSet {
            countryCurrenyView.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 5)
        }
    }
    //MARK:- Local Variables
    private let user = UserData.sharedInstance
    private let cp = CountryPickerView()
    private var countryModel = Country()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    //MARK:- Internal Methods
    private func setupUI(){
        setupNavigationBar()
        setupCountryPicker()
        setUserCountryCurrrencyUI()
    }
    private func setUserCountryCurrrencyUI() {
        currenyCountryLbl.text = user.userModel.userAddress.first?.countryModel.countryCurrency ?? countryModel.countryCurrency
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
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
        countryModel = cp.selectedCountry
    }
    
    //MARK:- IBActions

    @IBAction func continueBtnAction(_ sender: UIButton) {
    }
    
}

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
                    self.user.userModel = userModel
                    switch userModel.userVerified {
                    case .ongoing:
                        Utility.VerificationPendingRootVC()
                    case .verified:
                        self.setUserCountryCurrrencyUI()
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

//MARK:- CountryPickerViewDataSource & CountryPickerViewDelegateMethods
extension SendMoneyVC: CountryPickerViewDataSource, CountryPickerViewDelegate {
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
         
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
     
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
     
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryModel = country
     }
 }
