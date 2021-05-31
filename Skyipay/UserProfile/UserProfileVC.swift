//
//  UserProfileVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 24/04/21.
//

import UIKit
import CountryPickerView
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
    @IBOutlet weak var dobButton: UIButton!
    
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
    var userModel = UserModel()
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
        datpickerview.maximumDate = Date()
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
        userNameTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        userEmailTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        phoneNumberTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        userGenderTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        dobTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        couuntryTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        languagesTxtFld.isUserInteractionEnabled = profileMode != .viewMode
        dobButton.isUserInteractionEnabled = profileMode != .viewMode
    }
    
    private func updateUI() {
        self.userNameTxtFld.text = userModel.userName
        self.userEmailTxtFld.text = userModel.email
        countryCodeLbl.text = "(\(userModel.dialCode))-"
        self.phoneNumberTxtFld.text = userModel.userPhoneNumber
        self.userGenderTxtFld.text = userModel.userGender
        self.dobTxtFld.text = userModel.userDOB
        self.couuntryTxtFld.text = userModel.userAddress.first?.countryModel.countryName ?? ""
        self.languagesTxtFld.text = ""
        if let imageURL = URL.init(string: userModel.userImageUrl) {
            userProfileImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "UserProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            userProfileImg.image = UIImage(named: "UserProfile")
        }
        let imageData: Data? = userProfileImg.image?.pngData()
        if let data = imageData {
            self.imagedict["profile_image"] = data
        }
    }
    
    private func getFirstLastName(firstNameRequire:Bool) -> String{
        let firstName =  self.userNameTxtFld.text?.components(separatedBy: " ").first ?? ""
        let lastName =  self.userNameTxtFld.text?.components(separatedBy: " ").last ?? ""
        return firstNameRequire ? firstName : lastName
    }
    
    private func updateSignleton() {
        self.user.userID = userModel.userID
        self.user.userModel = userModel
    }
    /// Hiding Picker View
    private func hidePickerView(){
        datepickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    func image(getImage: UIImage, isEqualTo currentImage: UIImage) -> Bool {
        let data1: Data = getImage.pngData()!
        let data2: Data = currentImage.pngData()!
        return data1 == data2
    }
    
    //MARK:- IBActions
    override func leftButtonAction() {
        switch screenOpendBy {
        case .setRoot:
            Utility.appDelegate.window?.rootViewController = user.rootVC
        default:
            self.navigationController?.popViewController(animated: true)
        }
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
            let imageData: Data? = image.pngData()
            if let data = imageData {
                self.imagedict["profile_image"] = data
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
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: getUserProfileUrl, method: .get, parameters: nil, headers: headers,completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                    let userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.dataKey]!)
                    self.userModel = userModel
                    self.updateUI()
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
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.uploadDocuments(url: uploadImgUrl, method: .post, imagesDict: self.imagedict, parameters: nil,headers: headers) { (json, status) in
                self.dispatchgp.leave()
                guard let jsonValue = json?.dictionaryValue else {
                   self.view.makeToast(status, duration: 3.0, position: .bottom)
                   self.dismissHUD(isAnimated: true)
                   return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
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
                "first_name": self.getFirstLastName(firstNameRequire: true),
                "last_name": self.getFirstLastName(firstNameRequire: false),
                "email": self.userEmailTxtFld.text!,
                "dial_code": "\(String(describing: user.userModel.userAddress.first!.countryModel.countryDialCode))" ,
                "phone": self.phoneNumberTxtFld.text!,
                "dob":"1990-12-20",
                "gender":"Male",
                "languages": "English",
                "iso": user.userModel.userAddress.first?.countryModel.countryISOCode ?? "",
                "country_id": "\(String(describing: user.userModel.userAddress.first!.countryModel.countryId))"
            ] as [String : Any]
            print(parameters)
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: updateUserProfileUrl, method: .post, parameters: parameters,headers: headers, completionHandler: { (json, status) in
                self.dispatchgp.leave()
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
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
        self.couuntryTxtFld.text = country.countryName
        self.countryCodeLbl.text = "(\(country.countryDialCode))-"
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
