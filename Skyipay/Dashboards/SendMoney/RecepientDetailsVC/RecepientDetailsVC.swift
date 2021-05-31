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
    //MARK:- Properties
    private let userInfo = UserData.sharedInstance
    //MARK:- Local Variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private let cp = CountryPickerView()
    private var recipients = [RecipientDetail]()
    private var selectedRecipient = RecipientDetail()
    //MARK:- Life Cycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountryPicker()

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
        } else if (recipientCityTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Recipient City can't be empty", duration: 3.0, position: .center)
        } else if (recipientCountry.text?.isEmpty ??  true) {
            self.view.makeToast("Select recipient coutry", duration: 3.0, position: .center)
        } else {
            userInfo.selectedTab = .bankDeposit
            subVCdelegate?.continueButtonTapped()
        }
    }
}

//MARK:- GenericPickerDataSourceDelegate Methods
extension RecepientDetailsVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
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
        self.recipientCountry.text = country.countryName
     }
}

//MARK:- API Call Methods
extension RecepientDetailsVC {
    private func getRecipientList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let bankListUrl : String = URLNames.baseUrl + URLNames.bankList
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: bankListUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        Utility.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let recipientList = jsonValue[APIFields.dataKey]?.array {
                        var recipients = Array<RecipientDetail>()
                        for recipient in recipientList {
                            let recipientObj = RecipientDetail.init(json: recipient)
                            recipients.append(recipientObj)
                        }
                        self.recipients = recipients
                        self.selectedRecipient = self.recipients.first ?? RecipientDetail()
                    }
                    DispatchQueue.main.async {
                        self.setPickerDataSourceDelegate(dataSourceArray: self.recipients.map{$0.recipientName})
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
