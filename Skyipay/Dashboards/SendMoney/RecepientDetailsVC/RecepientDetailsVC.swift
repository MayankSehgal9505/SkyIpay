//
//  RecepientDetailsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
import CountryPickerView

class RecepientDetailsVC: SendMoneySuperVC {
    //MARK:- IBOutlets
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var recipientPickerView: UIPickerView!
    @IBOutlet weak var previousRecipientLbl: UILabel!
    @IBOutlet weak var recipientFirstNameTxtFld: UITextField!
    @IBOutlet weak var recepientMiddleNametxtFld: UITextField!
    @IBOutlet weak var recipientSurnameTxtFld: UITextField!
    @IBOutlet weak var recipientSecondSurnameTxtFld: UITextField!
    @IBOutlet weak var recipientAddressTxtFld: UITextField!
    @IBOutlet weak var recipientCityTxtFld: UITextField!
    @IBOutlet weak var recipientCountry: UILabel!
    @IBOutlet weak var postCodeTextField: UITextField!
    //MARK:- Properties
    private let userInfo = UserData.sharedInstance
    private let sendMoneyInfo = SendMoney.sharedInstance
    //MARK:- Local Variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private let cp = CountryPickerView()
    private var recipients = [RecipientDetail]()
    private var selectedRecipient = RecipientDetail()
    private var receipientCountry = Country()
    private var beneficiaries = [BeneficiaryModel]()
    private var selectedBeneficary = BeneficiaryModel()
    private var selectedItem = ""
    //MARK:- Life Cycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountryPicker()
        getBeneficiariesList()
    }
    //MARK:- Internal Methods
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    /// set picker data source & delegates
    /// - Parameter dataSourceArray: data source array
    private func setPickerDataSourceDelegate(dataSourceArray:Array<String>) {
        pickerDataSource = GenericPickerDataSource(withItems: dataSourceArray)
        recipientPickerView.dataSource = pickerDataSource
        recipientPickerView.delegate = pickerDataSource
        pickerDataSource?.delegate = self
        recipientPickerView.reloadAllComponents()
    }
    /// Hiding Picker View
    private func hidePickerView(){
        pickerParentView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    //MARK:- IBActions
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func pickerDoneAction(_ sender: UIBarButtonItem) {
        self.selectedBeneficary = self.beneficiaries.filter({ model -> Bool in
            return model.beneficiaryFirstName == selectedItem
        }).first!
        previousRecipientLbl.text = self.selectedBeneficary.beneficiaryFirstName
        recipientFirstNameTxtFld.text = self.selectedBeneficary.beneficiaryFirstName
        recepientMiddleNametxtFld.text = self.selectedBeneficary.beneficiaryMiddleName
        recipientSurnameTxtFld.text = self.selectedBeneficary.beneficiaryLastName
        recipientSecondSurnameTxtFld.text = self.selectedBeneficary.beneficiaryEmail
        recipientAddressTxtFld.text = self.selectedBeneficary.beneficiaryAddress
        recipientCityTxtFld.text = self.selectedBeneficary.beneficiaryCity
        postCodeTextField.text = self.selectedBeneficary.beneficiaryPostCode
        recipientCountry.text = self.selectedBeneficary.beneficiaryCountryName
        hidePickerView()
    }
    @IBAction func previousRecipientAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerParentView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerParentView, view: (self.parent?.view)!)
    }
    @IBAction func recipientCountyAction(_ sender: UIButton) {
        cp.showCountriesList(from: self)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (recipientFirstNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Recipient first name can't be empty", duration: 3.0, position: .center)
        } else if (recipientSurnameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Recipient Surname can't be empty", duration: 3.0, position: .center)
        } else if (recipientSecondSurnameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Recipient emailID can't be empty", duration: 3.0, position: .center)
        } else if (recipientCityTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Recipient City can't be empty", duration: 3.0, position: .center)
        } else if (postCodeTextField.text?.isEmpty ??  true) {
            self.view.makeToast("Post code can't be empty", duration: 3.0, position: .center)
        } else if (recipientCountry.text?.isEmpty ??  true) {
            self.view.makeToast("Select recipient coutry", duration: 3.0, position: .center)
        }  else {
            selectedRecipient.recipientFirstName =  recipientFirstNameTxtFld.text!
            selectedRecipient.recipientMiddleName = recepientMiddleNametxtFld.text!
            selectedRecipient.recipientSurName = recipientSurnameTxtFld.text!
            selectedRecipient.recipientEmail = recipientSecondSurnameTxtFld.text!
            selectedRecipient.recipientAddress = recipientAddressTxtFld.text!
            selectedRecipient.recipientCity = recipientCityTxtFld.text!
            selectedRecipient.recipientCountry = receipientCountry
            sendMoneyInfo.recipientDetails = selectedRecipient
            userInfo.selectedTab = .bankDeposit
            subVCdelegate?.continueButtonTapped()
        }
    }
}

//MARK:- GenericPickerDataSourceDelegate Methods
extension RecepientDetailsVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}

//MARK:- CountryPickerViewDataSource & CountryPickerViewDelegate Methods
extension RecepientDetailsVC: CountryPickerViewDataSource, CountryPickerViewDelegate{
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
        receipientCountry = country
        self.recipientCountry.text = country.countryName
     }
}

//MARK:- API Call Methods
extension RecepientDetailsVC {
    private func getBeneficiariesList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let faqURL : String = URLNames.baseUrl + URLNames.beneficiaryList
            print(faqURL)
            //http://dev.equalinfotech.in/skyipay/api/user/receipientlist
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            let params = [
                "user_id": "\(String(describing: Defaults.getUserID()!))",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .post, parameters: params,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        Utility.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let beneficiarylist = jsonValue[APIFields.dataKey]?.array {
                        var beneficiaries = Array<BeneficiaryModel>()
                        for beneficiary in beneficiarylist {
                            let beneficiaryModel = BeneficiaryModel.init(json: beneficiary)
                            beneficiaries.append(beneficiaryModel)
                        }
                        self.beneficiaries = beneficiaries
                        self.selectedItem = self.beneficiaries.map{$0.beneficiaryFirstName}.first!
                    }
                    DispatchQueue.main.async {
                        self.setPickerDataSourceDelegate(dataSourceArray: self.beneficiaries.map{$0.beneficiaryFirstName})
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    Utility.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }

}
