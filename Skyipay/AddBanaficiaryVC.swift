//
//  AddBanaficiaryVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 29/09/21.
//

import UIKit
import CountryPickerView

class AddBanaficiaryVC: BaseViewController {
    enum DatePickerType:Int {
        case dob = 0
        case issueDate, expiryDate
    }
    enum NormalPickerType:Int {
        case id = 0
        case occupation, bank
    }
    enum CountryType: Int {
        case issueCountry = 0
        case county, country
    }
    //MARK:- IBOutlets

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var emailTtFld: UITextField!
    @IBOutlet weak var phoneNumberTtFld: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    @IBOutlet weak var idTypeTxtFld: UITextField!
    @IBOutlet weak var idNumberTxtFld: UITextField!
    @IBOutlet weak var issueCountryTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var cityTextFld: UITextField!
    @IBOutlet weak var countyTtFld: UITextField!
    @IBOutlet weak var postCodeTxtFld: UITextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var issueDateTxtFld: UITextField!
    @IBOutlet weak var expiryDateTxtFld: UITextField!
    @IBOutlet weak var occupationTxtFld: UITextField!
    @IBOutlet weak var bankTxtFld: UITextField!
    @IBOutlet weak var accountNumTxtFld: UITextField!


    @IBOutlet weak var datePickerParentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLbl: UILabel!

    @IBOutlet weak var pickerViewMain: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerLbl: UILabel!
    //MARK:- Local Variables
    private let user = UserData.sharedInstance
    private var effectView,vibrantView : UIVisualEffectView?
    private var datePickerType: DatePickerType = .dob
    private var normalPickerType: NormalPickerType = .id
    private var countryType: CountryType = .issueCountry
    let cp = CountryPickerView()
    var issuecountry = Country()
    var county = Country()
    var country = Country()
    private var pickerDataSource: GenericPickerDataSource?
    var dispatchGP = DispatchGroup()
    private var banks = [Bank]()
    private var selectedBank = Bank() {
        didSet {
            self.bankTxtFld.text = selectedBank.bankName
        }
    }
    private var idDocuments = [IDDocument]()
    private var selectedidDocument = IDDocument() {
        didSet {
            self.idTypeTxtFld.text = selectedidDocument.iDTitle
        }
    }
    private var occupations = [Occupation]()
    private var selectedOccupation = Occupation() {
        didSet {
            self.occupationTxtFld.text = selectedOccupation.occupationTitle
        }
    }
    var selecteddate = ""
    var selectedItem = ""
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callAPIs()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func callAPIs() {
        showHUD(progressLabel: AlertField.loaderString)
        dispatchGP.enter()
        dispatchGP.enter()
        dispatchGP.enter()
        getBankList()
        getOccupations()
        getidDocuments()
        dispatchGP.notify(queue: .main) {
            self.dismissHUD(isAnimated: true)
        }
    }
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    private func setUpUI(){
        self.setTitle(navigationTitle: "Add Beneficiary")
        enableLeftBtn(withIcon: "leftArrow")
        setupCountryPicker()
    }

    /// Hiding Picker View
    private func hidePickerView(){
        datePickerParentView.isHidden = true
        pickerViewMain.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
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

    //MARK:- IBActions
    @IBAction func cancelPickerBtn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func donePickerBtn(_ sender: UIBarButtonItem) {
        switch normalPickerType {
        case .id:
            if !selectedItem.isEmpty {
                self.selectedidDocument = self.idDocuments.filter({ model -> Bool in
                    return model.iDTitle == selectedItem
                }).first!
            }
        case .occupation:
            if !selectedItem.isEmpty {
                self.selectedOccupation = self.occupations.filter({ model -> Bool in
                    return model.occupationTitle == selectedItem
                }).first!
            }
        case .bank:
            if !selectedItem.isEmpty {
                self.selectedBank = self.banks.filter({ model -> Bool in
                    return model.bankName == selectedItem
                }).first!
            }
        }
        hidePickerView()
    }
    @IBAction func pickerDoneBtnAction(_ sender: UIBarButtonItem) {
        switch datePickerType {
        case .dob:
            dobTxtFld.text = selecteddate
        case .issueDate:
            issueDateTxtFld.text = selecteddate
        case .expiryDate:
            expiryDateTxtFld.text = selecteddate
        }
        hidePickerView()
    }
    @IBAction func pickerCancelBtnAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    override func leftButtonAction() {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func dobBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datePickerParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datePickerParentView.isHidden = false
        dateLbl.text = "D.O.B"
        datePickerType = .dob
        datePicker.maximumDate = Date()
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datePickerParentView, view: self.view)
    }

    @IBAction func idTypeBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerViewMain)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerViewMain.isHidden = false
        pickerLbl.text = "ID Type"
        normalPickerType = .id
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerViewMain, view: self.view)
        self.setPickerDataSourceDelegate(dataSourceArray: self.idDocuments.map{$0.iDTitle})
    }

    @IBAction func issueDateBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datePickerParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datePickerParentView.isHidden = false
        dateLbl.text = "Issue Date"
        datePickerType = .issueDate
        datePicker.maximumDate = Date()
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datePickerParentView, view: self.view)
    }
    
    @IBAction func expiryDateBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datePickerParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datePickerParentView.isHidden = false
        dateLbl.text = "Expiry Date"
        datePickerType = .expiryDate
        datePicker.maximumDate = nil
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datePickerParentView, view: self.view)
    }
    

    @IBAction func occupationBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerViewMain)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerViewMain.isHidden = false
        pickerLbl.text = "Choose Occupation"
        normalPickerType = .occupation
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerViewMain, view: self.view)
        self.setPickerDataSourceDelegate(dataSourceArray: self.occupations.map{$0.occupationTitle})
    }

    @IBAction func bankBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerViewMain)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerViewMain.isHidden = false
        pickerLbl.text = "Choose Bank"
        normalPickerType = .bank
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerViewMain, view: self.view)
        self.setPickerDataSourceDelegate(dataSourceArray: self.banks.map{$0.bankName})
    }

    @IBAction func issueCountry(_ sender: UIButton) {
        countryType = .issueCountry
        cp.showCountriesList(from: self)
    }

    @IBAction func countyBtnAction(_ sender: UIButton) {
        countryType = .county
        cp.showCountriesList(from: self)
    }
    
    @IBAction func countryBtnAction(_ sender: UIButton) {
        countryType = .country
        cp.showCountriesList(from: self)
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selecteddate = dateFormatter.string(from: sender.date)
    }
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (firstNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("First name can't be empty", duration: 3.0, position: .center)
        } else if (lastNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Last name can't be empty", duration: 3.0, position: .center)
        } else if (emailTtFld.text?.isEmpty ??  true) {
            self.view.makeToast("EmailID can't be empty", duration: 3.0, position: .center)
        } else if (phoneNumberTtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone number can't be empty", duration: 3.0, position: .center)
        } else if (idNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("ID number can't be empty", duration: 3.0, position: .center)
        } else if (addressTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Address can't be empty", duration: 3.0, position: .center)
        } else if (cityTextFld.text?.isEmpty ??  true) {
            self.view.makeToast("City can't be empty", duration: 3.0, position: .center)
        } else if (postCodeTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Post Code can't be empty", duration: 3.0, position: .center)
        }else {
            addBeneficiaryCall()
        }

    }
}

//MARK:- CountryPickerViewDelegate Methods
extension AddBanaficiaryVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        switch countryType {
        case .issueCountry:
            issuecountry = country
            issueCountryTxtFld.text = country.countryName
        case .county:
            county = country
            countyTtFld.text = country.countryName
        case .country:
            self.country = country
            countryTxtFld.text = country.countryName
        }
//        self.couuntryTxtFld.text = country.countryName
//        self.countryCodeLbl.text = "(\(country.countryDialCode))-"
     }
 }

//MARK:- CountryPickerViewDataSource Methods
extension AddBanaficiaryVC: CountryPickerViewDataSource {
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

//MARK:- GenericPickerDataSourceDelegate Methods
extension AddBanaficiaryVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}

//MARK:- API Call Methods
extension AddBanaficiaryVC {
    private func getOccupations() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let occupationListUrl : String = URLNames.baseUrl + URLNames.occupationList
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: occupationListUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dispatchGP.leave()
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let occupationList = jsonValue[APIFields.dataKey]?.array {
                        var occupations = Array<Occupation>()
                        for occupation in occupationList {
                            let occupationObj = Occupation.init(json: occupation)
                            occupations.append(occupationObj)
                        }
                        self.occupations = occupations
                        self.selectedOccupation = self.occupations.first ?? Occupation()
                    }
                    DispatchQueue.main.async {
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dispatchGP.leave()
                }
            })
        }else{
            self.dispatchGP.leave()
            self.showNoInternetAlert()
        }
    }

    private func getidDocuments() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let idDocumentsListUrl : String = URLNames.baseUrl + URLNames.idDocuments
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: idDocumentsListUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dispatchGP.leave()
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let IDList = jsonValue[APIFields.dataKey]?.array {
                        var IDS = Array<IDDocument>()
                        for id in IDList {
                            let iDDocumentObj = IDDocument.init(json: id)
                            IDS.append(iDDocumentObj)
                        }
                        self.idDocuments = IDS
                        self.selectedidDocument = self.idDocuments.first ?? IDDocument()
                    }
                    DispatchQueue.main.async {
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dispatchGP.leave()
                }
            })
        }else{
            self.dispatchGP.leave()
            self.showNoInternetAlert()
        }
    }

    private func getBankList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bankListUrl : String = URLNames.baseUrl + URLNames.bankList
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: bankListUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dispatchGP.leave()
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let bankList = jsonValue[APIFields.dataKey]?.array {
                        var banks = Array<Bank>()
                        for bank in bankList {
                            let bankObj = Bank.init(json: bank)
                            banks.append(bankObj)
                        }
                        self.banks = banks
                        self.selectedBank = self.banks.first ?? Bank()
                    }
                    DispatchQueue.main.async {
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dispatchGP.leave()
                }
            })
        }else{
            self.dispatchGP.leave()
            self.showNoInternetAlert()
        }
    }
}
extension AddBanaficiaryVC {
    private func addBeneficiaryCall(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let updateUserProfileUrl = URLNames.baseUrl + URLNames.addBeneficiary
            let parameters = [
                "first_name":firstNameTxtFld.text!,
                "last_name":lastNameTxtFld.text!,
                "email":emailTtFld.text!,
                "password":"123456",
                "dob":dobTxtFld.text!,
                "iso":country.countryISOCode,
                "country_id":country.countryId,
                "address":addressTxtFld.text!,
                "city":cityTextFld.text!,
                "county_id":"1",
                "postcode":postCodeTxtFld.text!,
                "country":country.countryId,
                "country_of_birth":country.countryId,
                "customer_type_id":"1",
                "gender":"Male",
                "occupation_id":selectedOccupation.id,
                "id_type":selectedidDocument.id,
                "id_number":idNumberTxtFld.text!,
                "id_card":"dnndn",
                "issue_date":issueDateTxtFld.text!,
                "expire_date":expiryDateTxtFld.text!,
                "ac_no":accountNumTxtFld.text!,
                "bank_name": selectedBank.bankName
            ] as [String : Any]
            print(parameters)
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: updateUserProfileUrl, method: .post, parameters: parameters,headers: headers, completionHandler: { (json, status) in
             guard let jsonValue = json?.dictionaryValue else {
                self.view.makeToast(status, duration: 3.0, position: .bottom)
                self.dismissHUD(isAnimated: true)
                return
             }
             if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                 if let _ =  jsonValue[APIFields.dataKey]?.array {
                    self.leftButtonAction()
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
