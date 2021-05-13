//
//  UserProfileVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 24/04/21.
//

import UIKit
import CountryPickerView
import SDWebImage
class UserProfileVC: BaseViewController {
    //MARK:- enums
    enum ProfileMode {
        case viewMode
        case editMode
    }
    
    enum ScreenOpenedBy {
        case pushed
        case setRoot
    }
    //MARK:- IBOutlets
    @IBOutlet weak var userProfileImg: UIImageView! {
        didSet {
            userProfileImg.makeCircularView(withBorderColor: .white, withBorderWidth: 5.0, withCustomCornerRadiusRequired: false, withCustomCornerRadius: 0.0)
        }
    }
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var chooseImgBtn: UIButton!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var userEmailTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var userGenderTxtFld: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    @IBOutlet weak var couuntryTxtFld: UITextField!
    @IBOutlet weak var languagesTxtFld: UITextField!
    @IBOutlet var editIcons: [UIImageView]!
    @IBOutlet weak var datepickerMainView: UIView!
    @IBOutlet weak var datpickerview: UIDatePicker!
    @IBOutlet weak var countryCodeLbl: UILabel!
    
    //MARK:- Local Variables
    private var profileMode: ProfileMode = .viewMode
    private let user = UserData.sharedInstance
    private var effectView,vibrantView : UIVisualEffectView?
    let cp = CountryPickerView()
    var country = Country()
    private var dob = ""
    var dispatchgp = DispatchGroup()
    var imagedict:[String:Data] = [:]
    var screenOpendBy:ScreenOpenedBy = .setRoot
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getUserProfile()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    private func setUpUI(){
        setUpNavigationBar(updatetitle: true)
        enableLeftBtn(withIcon: "leftArrow")
        btnVisibility(profileMode: profileMode)
        setupCountryPicker()
    }
    
    private func setUpNavigationBar(updatetitle:Bool = false) {
        if updatetitle{
            self.setTitle(navigationTitle: "Profile")
        }
        let selector = profileMode == .viewMode ? #selector(self.editBtnAction) : #selector(self.saveBtnAction)
        let rightBarButtonItem = UIBarButtonItem.init(title: profileMode == .viewMode ? "Edit" : "Save", style: .plain, target: self, action: selector)
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func btnVisibility(profileMode:ProfileMode) {
        editIcons.forEach { $0.isHidden = profileMode == .viewMode }
        chooseImgBtn.isHidden = profileMode == .viewMode
        self.userEmailTxtFld.isUserInteractionEnabled = false
        self.userGenderTxtFld.isUserInteractionEnabled = false
    }
    
    private func updateUI(userInfo:UserModel) {
        self.userNameTxtFld.text = userInfo.firstName + " " + userInfo.lastname
        self.userEmailTxtFld.text = userInfo.email
        countryCodeLbl.text = "(\(userInfo.countryCode))-"
        self.phoneNumberTxtFld.text = "\(userInfo.userNumber)"
        self.userGenderTxtFld.text = userInfo.gender
        self.dobTxtFld.text = userInfo.dob
        self.couuntryTxtFld.text = userInfo.birthCountry
        self.languagesTxtFld.text = userInfo.languages
    }
    
    private func getFirstLastName(firstNameRequire:Bool) -> String{
        let firstName =  self.userNameTxtFld.text?.components(separatedBy: " ").first ?? ""
        let lastName =  self.userNameTxtFld.text?.components(separatedBy: " ").last ?? ""
        return firstNameRequire ? firstName : lastName
    }
    /// Hiding Picker View
    private func hidePickerView(){
        datepickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    //MARK:- IBActions
    override func leftButtonAction() {
        switch screenOpendBy {
        case .setRoot:
            Utility.appDelegate.window?.rootViewController = user.rootVC
        default:
            self.navigationController?.popViewController(animated: true)
        }
//        user.rootVC = Utility.appDelegate.window?.rootViewController as! UINavigationController
//        let navigationController = UINavigationController.init(rootViewController: updateProfile)
    }
    @objc private func editBtnAction() {
        profileMode = .editMode
        btnVisibility(profileMode: profileMode)
        setUpNavigationBar()
    }

    
    @IBAction func countryBtnTapped(_ sender: UIButton) {
        cp.showCountriesList(from: self)
    }
    @IBAction func dobBtnTapped(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datepickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datepickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datepickerMainView, view: self.view)
    }
    @IBAction func pickerDoneBtn(_ sender: UIBarButtonItem) {
        self.dobTxtFld.text = dob
        hidePickerView()

    }
    @IBAction func pickerCancelbtn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    
    @objc private func saveBtnAction() {
        if (userNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("User name can't be empty", duration: 3.0, position: .center)
        } else if (userEmailTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(userEmailTxtFld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else if (phoneNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone number can't be empty", duration: 3.0, position: .center)
        } else if (userGenderTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Gender can't be empty", duration: 3.0, position: .center)
        } else if (dobTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Date of birth can't be empty", duration: 3.0, position: .center)
        } else if (couuntryTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Couuntry can't be empty", duration: 3.0, position: .center)
        } else {
            profileMode = .viewMode
            btnVisibility(profileMode: profileMode)
            setUpNavigationBar()
            self.showHUD(progressLabel: AlertField.loaderString)
            updateUserProfile()
            updateUserImage()
        }
    }
    
    @IBAction func ddatePickerValueChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dob = dateFormatter.string(from: sender.date)
    }
    @IBAction func imageCaptureBtn(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            self.userProfileImg.image = image
            let imageData: Data? = image.jpegData(compressionQuality: 0.8)
            if let data = imageData {
                self.imagedict["profileImage"] = data
            }
        }

    }
}

// MARK: API Call
extension UserProfileVC {
    func getUserProfile() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getUserProfileUrl = URLNames.baseUrl + URLNames.getUserDetails
            let parameters = [
                "userId": !user.userModel.userID.isEmpty ? user.userModel.userID : Defaults.getUserID()
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: getUserProfileUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.dataKey]!)
                    SDWebImageManager.shared.loadImage(with: URL.init(string: userModel.userImageUrl), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
                        guard let sself = self else { return }
                        if let _ = error {
                            // Do something with the error
                            return
                        }
                        guard let img = image else {
                            // No image handle this error
                            return
                        }
                        sself.userProfileImg.image = img
                    })
                    self.user.userID = userModel.userID
                    self.user.userPhoneNumber = userModel.userNumber
                    self.user.userModel = userModel
                    self.updateUI(userInfo:userModel)
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
    func updateUserImage() {
        self.dispatchgp.enter()
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let uploadImgUrl : String = URLNames.baseUrl + URLNames.uploadImage
            let parameters = [
                "userId":!user.userModel.userID.isEmpty ? user.userModel.userID : Defaults.getUserID(),
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.uploadDocuments(url: uploadImgUrl, method: .post, imagesDict: self.imagedict, parameters: parameters) { (json, status) in
                self.dispatchgp.leave()
                guard let jsonValue = json?.dictionaryValue else {
                   self.view.makeToast(status, duration: 3.0, position: .bottom)
                   self.dismissHUD(isAnimated: true)
                   return
                }
                if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                }
                else {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                }
                self.dismissHUD(isAnimated: true)
            }
        }else{
            self.showNoInternetAlert()
        }
    }

    
    func updateUserProfile() {
        dispatchgp.enter()
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let updateUserProfileUrl = URLNames.baseUrl + URLNames.updateUserDetails
            let parameters = [
                "user_id": !user.userModel.userID.isEmpty ? user.userModel.userID : Defaults.getUserID(),
                "firstname": self.getFirstLastName(firstNameRequire: true),
                "lastname": self.getFirstLastName(firstNameRequire: false),
                "email": self.userEmailTxtFld.text!,
                "country_code": !user.usercountry.phoneCode.isEmpty ? user.usercountry.phoneCode : user.userModel.countryCode,
                "phonenumber": self.phoneNumberTxtFld.text!,
                "dob":self.dobTxtFld.text!,
                "country_birth":self.couuntryTxtFld.text!,
                "languages": ""
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: updateUserProfileUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                self.dispatchgp.leave()
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.dataKey]!)
                    self.user.userID = userModel.userID
                    self.user.userPhoneNumber = userModel.userNumber
                    self.user.userModel = userModel
                    self.updateUI(userInfo:userModel)
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

//MARK:- CountryPickerViewDelegate Methods
extension UserProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        user.usercountry = country
        self.couuntryTxtFld.text = country.name
        self.countryCodeLbl.text = "(\(country.phoneCode))-"
     }
 }

//MARK:- CountryPickerViewDataSource Methods
extension UserProfileVC: CountryPickerViewDataSource {
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
 }
