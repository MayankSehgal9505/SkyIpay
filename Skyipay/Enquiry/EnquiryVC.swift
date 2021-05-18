//
//  EnquiryVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/05/21.
//

import UIKit
import CountryPickerView

class EnquiryVC: BaseViewController {
    //Mark:- enums
    enum PickerType {
        case genderPickerView
    }
    //MARK:- IBOutles
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var userNameTxtfld: UITextField!
    @IBOutlet weak var emailTxtfld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var genderTxtfld: UITextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var subjectTxtFld: UITextField!
    @IBOutlet weak var messageBodyView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var sendBtn: CustomButton!
    @IBOutlet weak var pickerMainView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerLbl: UILabel!
    @IBOutlet weak var phoneDialCode: UILabel!
    //MARK:- Local Variables
    private var pickerType: PickerType = .genderPickerView
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private var selectedItem = ""
    private let cp = CountryPickerView()
    private let user = UserData.sharedInstance
    private var placeholderLabel : UILabel!
    private var county = Country()
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }

    //MARK:- Internal Methods
    private func setUpUI() {
        self.setTitle(navigationTitle: "Enquiry")
        enableLeftBtn(withIcon: "leftArrow")
        county = user.userModel.userAddress.first?.countryModel ?? Country()
        setupCountryPicker()
        setupInitialUi()
        sendBtn.dropShadow(color: UIColor.init(red: 11/255, green: 19/255, blue: 57/255, alpha: 0.8), opacity: 0.7, offSet: CGSize(width: 0, height: 1), radius: 10, scale: true)
        setupTextView()
    }
    private func setupTextView() {
        messageBodyView.makeCircularView(withBorderColor: .gray, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 0.0)
        messageTxtView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = EnquiyVC.messsagePlaceHolder
        placeholderLabel.font = UIFont.systemFont(ofSize: (messageTxtView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTxtView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTxtView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTxtView.text.isEmpty
    }
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    
    private func setupInitialUi(){
        self.genderTxtfld.text = Common.genderArray.first!
        phoneDialCode.text = "(\(county.countryDialCode))-"
        setupCountryPicker()
        setPickerDataSourceDelegate(dataSourceArray: Common.genderArray)
        self.countryTxtFld.text = county.countryName
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
        pickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    //MARK:- IBActions
    override func leftButtonAction() {
        Utility.appDelegate.window?.rootViewController = user.rootVC
    }
    @IBAction func donePickerrAction(_ sender: UIBarButtonItem) {
        switch pickerType {
        case .genderPickerView:
            self.genderTxtfld.text = selectedItem
        }
        hidePickerView()
    }
    @IBAction func cancelPickerAction(_ sender: UIBarButtonItem) {
        hidePickerView()
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
    @IBAction func sendBtnAction(_ sender: UIButton) {
        if (userNameTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("User name can't be empty", duration: 3.0, position: .center)
        } else if (emailTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(emailTxtfld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else if (phoneTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone number can't be empty", duration: 3.0, position: .center)
        } else if (genderTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Please select gender", duration: 3.0, position: .center)
        } else if (countryTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Country can't be empty", duration: 3.0, position: .center)
        } else if (subjectTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Subject can't be empty", duration: 3.0, position: .center)
        }else if (messageTxtView.text?.isEmpty ??  true) {
            self.view.makeToast("Message can't be empty", duration: 3.0, position: .center)
        } else {
            sendEnquiry()
        }
    }
}
//MARK:- GenericPickerDataSourceDelegate Methods
extension EnquiryVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}

//MARK:- CountryPickerViewDelegate Methods
extension EnquiryVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.county = country
        phoneDialCode.text = "(\(county.countryDialCode))-"
        self.countryTxtFld.text = country.countryName
     }
}
//MARK:- CountryPickerViewDataSource Methods
extension EnquiryVC: CountryPickerViewDataSource {
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

//MARK:- UITextViewDelegate Methods
extension EnquiryVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


//MARK:- API Calls
extension EnquiryVC {
    func sendEnquiry() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let sendEnquiryURL = URLNames.baseUrl + URLNames.enquiry
            let parameters = [
                "name":userNameTxtfld.text!,
                "email":emailTxtfld.text!,
                "dial_code": "\(county.countryDialCode)",
                "phone": phoneTxtFld.text!,
                "gender": genderTxtfld.text!,
                "country": county.countryName,
                "subject": subjectTxtFld.text!,
                "message": messageTxtView.text!
            ] as [String : Any]
            print(parameters)
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: sendEnquiryURL, method: .post, parameters: parameters,headers: headers, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    DispatchQueue.main.async {
                        self.view.makeToast(EnquiyVC.enquirySuccessfull, duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.leftButtonAction()
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
