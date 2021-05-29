 //
//  LoginVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 17/04/21.
//

import UIKit
import CountryPickerView

 enum ScreenType {
    case login
    case register
 }
class LoginVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var numberView: UIView! {    didSet {
        numberView.makeCircularView(withBorderColor: .lightText, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 25.0)  }
    }
    @IBOutlet weak var nextbtn: CustomButton!
    @IBOutlet weak var loginRegisterLbl: UILabel!
    @IBOutlet weak var loginRegisterBtn: UIButton!
    @IBOutlet weak var numberTxtFld: UITextField!
    //MARK:- Local Variables
    typealias screenType = ScreenType
    var typeOfScreen: ScreenType = .login
    private let user = UserData.sharedInstance
    private var userObj = UserModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupCountryPickerView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    //MARK:- Interal Methods
    
    /// set Up UI
    private func setupUI() {
        // by default next bbutton is disabled.
        nextbtn.isEnabled = false
        // set ui according to screen type i.e login or register screen
        loginRegisterLbl.text = typeOfScreen == .login ? LoginRegisterUI.registerMsg : LoginRegisterUI.loginMsg
        loginRegisterBtn.setTitle(typeOfScreen == .login ? LoginRegisterUI.registerBtnTitle : LoginRegisterUI.loginBtnTitle, for: [])
        // set textfield text
        numberTxtFld.text = ""
        numberTxtFld.delegate = self
    }
    
    private func setupCountryPickerView() {
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        cp.hostViewController = self
        numberTxtFld.leftView = cp
        numberTxtFld.leftViewMode = .always
        cp.dataSource = self
        cp.delegate = self
        //user.usercountry = cp.selectedCountry
        var addressModelObj = AddressModel()
        addressModelObj.countryModel = cp.selectedCountry
        user.userModel.userAddress = [addressModelObj]
    }
    
    private func moveToValidateScreen() {
        let validateOtpVC = ValidateOTPVC()
        switch typeOfScreen {
        case .login:
            validateOtpVC.typeOfScreen = .login
        default:
            validateOtpVC.typeOfScreen = .register
        }
        validateOtpVC.userObj = userObj
        self.navigationController?.pushViewController(validateOtpVC, animated: true)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /// perform next action acc. to screen type on tap of next
    /// - Parameter sender: nextbtn
    @IBAction func nextBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
         if (self.numberTxtFld.text?.isEmpty)! {
            self.view.makeToast(AlertField.numberEmpty, duration: 3.0, position: .bottom)
        } else if (self.numberTxtFld.text!.count < 10 || self.numberTxtFld.text!.count > 10) {
             self.view.makeToast(AlertField.invalidNumber, duration: 3.0, position: .bottom)
        }else {
            user.userPhoneNumber = self.numberTxtFld.text!
            userObj.userPhoneNumber = self.numberTxtFld.text!
            self.loginAPI()
        }
    }
    
    /// Open loginn screen on tap of login & register screen on tap of register
    /// - Parameter sender: loginRegisterBtn
    @IBAction func loginRegisterBtnTapped(_ sender: UIButton) {
        // update screen type
        typeOfScreen = typeOfScreen == .login ? .register : .login
        // update screen again
        setupUI()
    }
    @IBAction func numberTextfieldChanges(_ sender: UITextField) {
        nextbtn.isEnabled = sender.text?.count ?? 0 == 10
    }
}

 extension LoginVC: UITextFieldDelegate {
    
 }

 // MARK: API Call
 extension LoginVC:GetOtp {
    
    func loginAPI() {
        callLoginAPI(screenType: typeOfScreen, countryCode: "\(user.usercountry.countryDialCode)", phoneNumber: user.userPhoneNumber){ 
            self.moveToValidateScreen()
        }
    }
}

extension LoginVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        user.usercountry = country
     }
 }

 extension LoginVC: CountryPickerViewDataSource {
     func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
         return "Select a Country"
     }
         
     func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
     }
     
     func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
         return true
     }
     
     func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
     }
 }

