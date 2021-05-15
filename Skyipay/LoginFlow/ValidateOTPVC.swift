//
//  ValidateOTPVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import UIKit
class ValidateOTPVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var verificationOtpString: UILabel!
    @IBOutlet weak var sendOtpAgainString: UILabel!
    @IBOutlet weak var resentOtp: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet var otpTxtFlds: [OTPTextField]!
    
    //MARK:- Local Properties
    typealias screenType = ScreenType
    var typeOfScreen: ScreenType = .login
    private var timer : Timer?
    private var timelimit = 0
    private let user = UserData.sharedInstance
    var userObj = UserModel()
    private var otpString = ""
    var remainingStrStack: [String] = []

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextfields()
    }

    //MARK:- Internal Methods
    private func setupUI() {
        resentOtp.isEnabled =  false
        nextBtn.isEnabled = false
        verificationOtpString.text = String(format: ValidateOTPUI.validateOTPMsg,user.userPhoneNumber)
        initializeTimer()
    }
    
    private func setupTextfields() {
        for index in 0..<otpTxtFlds.count{
            otpTxtFlds[index].delegate = self
            //Adding a marker to previous field
            index != 0 ? (otpTxtFlds[index].previousTextField = otpTxtFlds[index-1]) : (otpTxtFlds[index].previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (otpTxtFlds[index-1].nextTextField = otpTxtFlds[index]) : ()
        }
    }
    private func initializeTimer() {
        timelimit = 59
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    @objc private func startTimer() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        if timelimit == 0 {
            timer?.invalidate()
            timer = nil
            sendOtpAgainString.attributedText = NSAttributedString(string: ValidateOTPUI.resendOTPWithOutTime, attributes: underlineAttribute)
            resentOtp.isEnabled = true
        } else {
            timelimit = timelimit-1
            sendOtpAgainString.attributedText = NSAttributedString(string: String(format: ValidateOTPUI.resendOTPWithTime, "\(timelimit)"), attributes: underlineAttribute)
        }
    }
    
    //gives the OTP text
    final func getOTP() -> String{
        for textField in otpTxtFlds{
            otpString += textField.text ?? ""
        }
        return otpString
    }
    private func moveToRegistrationScreen() {
        let registerVC = RegistrationVC()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    private func moveToVerificationPendingVC() {
        let verificationVC = VerifictionPendingVC()
        self.navigationController?.pushViewController(verificationVC, animated: true)
    }
    //MARK:- IBActions

    @IBAction func resendOtpAction(_ sender: UIButton) {
        getOtpAgainForlogin()
        setupUI()
    }
    
    @IBAction func changePhoneNumberAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        verifyOTP(user: userObj)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
// MARK: API Call
extension ValidateOTPVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let otpTxtFld = textField as! OTPTextField
        if (otpTxtFlds.index(of: otpTxtFld) == otpTxtFlds.count-1) {
            return true
        } else if otpTxtFld.nextTextField?.text?.isEmpty ?? false {
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        for fields in otpTxtFlds{
            if (fields.text == ""){
                nextBtn.isEnabled = false
                return
            }
        }
        nextBtn.isEnabled = true
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in otpTxtFlds {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
    }
}
// MARK: API Call
extension ValidateOTPVC:GetOtp {
   
   func getOtpAgainForlogin() {
    callLoginAPI(screenType: typeOfScreen, countryCode: "\(user.usercountry.countryDialCode)", phoneNumber: user.userPhoneNumber){
        self.setupUI()
    }
   }
    
    func verifyOTP(user:UserModel){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let verifyOTPURL = URLNames.baseUrl + URLNames.verifyOTP
            let parameters = [
                "phone":user.userPhoneNumber,
                "otp":"111111",
                "device_token": Defaults.getDeviceToken(),
                "device_type": DeviceType.ios.rawValue
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: verifyOTPURL, method: .post, parameters: parameters,headers: nil, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let dict =  jsonValue[APIFields.dataKey]?.dictionaryValue {
                       if let accessToken = dict[APIFields.accessTokenKey]?.stringValue {
                           Defaults.setAccessToken(accessToken: accessToken)
                       }
                       if let userIDValue = dict["user_id"]?.intValue {
                           Defaults.setUserID(userID: userIDValue)
                       }
                        if let verificationDone = dict["is_verify"]?.intValue,let verificationStatus = VerificationStatus.init(rawValue: verificationDone), let haveDocuments = dict["have_documents"]?.intValue, let documentStatus = DocumentStatus.init(rawValue: haveDocuments) {
                            switch (verificationStatus,documentStatus) {
                            case (.verified,.docummentPresent):
                                Defaults.setUserLoggedIn(userLoggedIn: true)
                                Utility.setHomeRootVC()
                            case (.verified,.docummentAbsent):
                                Defaults.setUserLoggedIn(userLoggedIn: true)
                                Utility.setHomeRootVC()
                                break
                            case (.ongoing, .docummentPresent):
                                self.moveToVerificationPendingVC()
                            case (.ongoing, .docummentAbsent):
                                self.moveToRegistrationScreen()
                            default:
                                break
                            }
                        } else {
                            self.moveToRegistrationScreen()
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
}
