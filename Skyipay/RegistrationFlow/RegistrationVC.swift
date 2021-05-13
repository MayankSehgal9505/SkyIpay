//
//  RegistrationVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import UIKit
import CountryPickerView


class RegistrationVC: BaseViewController {
    enum PickerType {
        case dobPickerView
        case genderPickerView
    }
    //MARK:-IBOutlets
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var nationalityTxtFld: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var genderTxtFld: UITextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var dobPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerMainView: UIView!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nextBtn: CustomButton!
    //MARK:- Local variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    let genderArray = ["Male", "Female", "Other"]
    private var selectedItem = ""
    private var pickerType: PickerType = .dobPickerView
    let cp = CountryPickerView()
    private let user = UserData.sharedInstance
    private var dob = ""
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(navigationTitle: "Personal Details")
        setupInitialUi()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Call the roundCorners() func right there.
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    private func setupInitialUi(){
        self.genderTxtFld.text = genderArray.first!.lowercased()
        setupCountryPicker()
        setPickerDataSourceDelegate(dataSourceArray: genderArray)
        self.countryTxtFld.text = user.usercountry.name
        dobPicker.maximumDate = Date()
    }
    /// set picker data source & delegates
    /// - Parameter dataSourceArray: data source array
    private func setPickerDataSourceDelegate(dataSourceArray:Array<String>) {
        pickerDataSource = GenericPickerDataSource(withItems: dataSourceArray)
        pickerView.dataSource = pickerDataSource
        pickerView.delegate = pickerDataSource
        pickerDataSource?.delegate = self
        pickerView.reloadAllComponents()
    }
    /// Hiding Picker View
    private func hidePickerView(){
        dobPickerView.isHidden = true
        pickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    private func moveToUploadDocuments() {
        let uploadDocument = UploadDocumentsVC()
        self.navigationController?.pushViewController(uploadDocument, animated: true)
    }
    
    
    //MARK:- IBActions
    @IBAction func dobBtnAction(_ sender: UIButton) {
        pickerType = .dobPickerView
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(dobPickerView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.dobPickerView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: dobPickerView, view: self.view)
    }
    @IBAction func countryBtnAction(_ sender: UIButton) {
        cp.showCountriesList(from: self)
    }
    
    @IBAction func genderBtnAction(_ sender: UIButton) {
        pickerType = .genderPickerView
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerMainView, view: self.view)
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (firstNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("First name can't be empty", duration: 3.0, position: .center)
        } else if (lastNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Last name can't be empty", duration: 3.0, position: .center)
        } else if (emailTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(emailTxtFld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else if (passwordTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Password can't be empty", duration: 3.0, position: .center)
        } else if (nationalityTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Nationality can't be empty", duration: 3.0, position: .center)
        } else if (dobTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Date of birth can't be empty", duration: 3.0, position: .center)
        } else if (countryTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Couuntry can't be empty", duration: 3.0, position: .center)
        } else {
            sendUserDetails()
        }
    }
    
    @IBAction func cacelPickerViewAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func donePickerViewAction(_ sender: UIBarButtonItem) {
        switch pickerType {
        case .dobPickerView:
            self.dobTxtFld.text = dob
        default:
            self.genderTxtFld.text = selectedItem.lowercased()
        }
        hidePickerView()
    }
    @IBAction func openClosePassword(_ sender: UIButton) {
        passwordTxtFld.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    @IBAction func textfieldValueChanges(_ sender: UITextField) {}
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        print("print \(sender.date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dob = dateFormatter.string(from: sender.date)
   }
}

//MARK:- GenericPickerDataSourceDelegate Methods
extension RegistrationVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}

//MARK:- CountryPickerViewDelegate Methods
extension RegistrationVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        user.usercountry = country
        self.countryTxtFld.text = country.name
     }
 }

//MARK:- CountryPickerViewDataSource Methods
extension RegistrationVC: CountryPickerViewDataSource {
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
//MARK:- API call
extension RegistrationVC {
    private func sendUserDetails(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let userSignupUrl : String = URLNames.baseUrl + URLNames.userSignup
            let parameters = [
                "userId":self.user.userModel.userID,
                "firstname":firstNameTxtFld.text!,
                "lastname":lastNameTxtFld.text!,
                "email":emailTxtFld.text!,
                "password":passwordTxtFld.text!,
                "dob":dobTxtFld.text!,
                "gender":genderTxtFld.text!,
                "country_birth":countryTxtFld.text!,
                "nationality":nationalityTxtFld.text!
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: userSignupUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.successKey], apiSuccess == "true" {
                 if let _ =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                    var userModel = UserModel.init(JsonDashBoard: jsonValue[APIFields.dataKey]!)
                    userModel.userNumber = self.user.userModel.userNumber
                    userModel.userID = self.user.userModel.userID
                    self.user.userModel = userModel
                    self.moveToUploadDocuments()
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
