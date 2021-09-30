//
//  TransferDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
import CountryPickerView

class TransferDetailVC: SendMoneySuperVC {

    enum ReceiveMoneyMethods:Int {
        case cash = 0
        case moneyWallet, bank
    }
    //MARK:- IBOutlets
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var destinationPickerView: UIPickerView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var payOutCurrencyValue: UILabel!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var feeAmountValue: UILabel!
    @IBOutlet weak var totalCostValue: UILabel!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var moneyWalletBtn: UIButton!
    @IBOutlet weak var bankBtn: UIButton!
    @IBOutlet weak var currencyConverterLbl: UILabel!
    @IBOutlet var receiveMoneyBtns: [UIButton]!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        getCurrencyConverters()
    }
    //MARK:- Local Variables
    private let userInfo = UserData.sharedInstance
    private let sendMoneyInfo = SendMoney.sharedInstance
    private let cp = CountryPickerView()
    private var feeObj = FeeModel()
    private var amountEntered = 0
    private var selectedCoutry = Country()
    private var currencyConverters = [CurrencyConverterModel]()
    private var selectedCurrencyConverter = CurrencyConverterModel() {
        didSet {
            self.countryLbl.text = self.selectedCurrencyConverter.currencyConverterCountry
            self.payOutCurrencyValue.text = self.selectedCurrencyConverter.currencyConverterCountryCurrency
            self.currencyConverterLbl.text = "1\(self.selectedCurrencyConverter.currencyConverterBaseCurrency) = \(self.selectedCurrencyConverter.currencyConverterRate)\(self.selectedCurrencyConverter.currencyConverterCountryCurrency)"
        }
    }
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private var selectedItem  = ""
    //MARK:- Internal Methods
    private func setupInitialUI() {
        setupCountryPicker()
        setupReceiveMoneyBtnsTags()
        amountTxtFld.delegate = self
    }
    
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    
    private func setupReceiveMoneyBtnsTags() {
        for (index,btn) in receiveMoneyBtns.enumerated() {
            btn.tag = ReceiveMoneyMethods.init(rawValue: index)!.rawValue
        }
    }
    /// set picker data source & delegates
    /// - Parameter dataSourceArray: data source array
    private func setPickerDataSourceDelegate(dataSourceArray:Array<String>) {
        pickerDataSource = GenericPickerDataSource(withItems: dataSourceArray)
        destinationPickerView.dataSource = pickerDataSource
        destinationPickerView.delegate = pickerDataSource
        pickerDataSource?.delegate = self
        destinationPickerView.reloadAllComponents()
    }
    /// Hiding Picker View
    private func hidePickerView(){
        pickerParentView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    private func checkReceiveMethod() -> Bool{
        var methodSelected = false
        for (_,btn) in receiveMoneyBtns.enumerated() {
            if btn.isSelected {
                methodSelected = true

            } else {
                continue
            }
        }
        return methodSelected
    }
    //MARK:- IBActions
    @IBAction func pickerDoneAction(_ sender: UIBarButtonItem) {
        self.selectedCurrencyConverter = self.currencyConverters.filter({ model -> Bool in
            return model.currencyConverterCountry == selectedItem
        }).first!
        if !(amountTxtFld.text?.isEmpty ?? false) {
            getFee(amount: amountTxtFld.text!)
        }
        hidePickerView()
    }
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func contiueAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (countryLbl.text?.isEmpty ??  true) {
            self.view.makeToast("Select Destination Country", duration: 3.0, position: .center)
        } else if (payOutCurrencyValue.text?.isEmpty ??  true) {
            self.view.makeToast("PayOut Currency can't be empty", duration: 3.0, position: .center)
        } else if (amountTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Amount can't be empty", duration: 3.0, position: .center)
        } else if (!checkReceiveMethod()) {
            self.view.makeToast("Choose How will they receive Money", duration: 3.0, position: .center)
        } else {
            var transferDetails = TransferDetails()
            transferDetails.transferCountry = selectedCoutry
            transferDetails.transferFee = self.feeAmountValue.text!
            transferDetails.transferTax = "0"
            transferDetails.transferAmout = self.amountTxtFld.text!
            sendMoneyInfo.transferDetails = transferDetails
            userInfo.selectedTab = .recipient
            subVCdelegate?.continueButtonTapped()
        }
    }
    
    @IBAction func amountChangeAction(_ sender: UITextField) {
    }
    @IBAction func countryBtnAction(_ sender: UIButton) {
        //cp.showCountriesList(from: self)
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerParentView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerParentView, view: (self.parent?.view)!)
    }
    @IBAction func receiveMoneyMethodAction(_ sender: UIButton) {
        guard let receiveMoneyType = ReceiveMoneyMethods.init(rawValue: sender.tag) else {return}
        receiveMoneyBtns.forEach { btn in
            btn.isSelected = btn.tag == receiveMoneyType.rawValue
        }
    }
    
}

//MARK:- CountryPickerViewDataSource & CountryPickerViewDelegate Methods
extension TransferDetailVC: CountryPickerViewDataSource, CountryPickerViewDelegate{
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
        selectedCoutry = country
        self.countryLbl.text = country.countryName
        payOutCurrencyValue.text = country.countryCurrency
     }
}
//MARK:- GenericPickerDataSourceDelegate Methods
extension TransferDetailVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}
extension TransferDetailVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTxtFld {
            getFee(amount:textField.text!)
        }
    }
}
//MARK:- API Call Methods
extension TransferDetailVC {
    private func getCurrencyConverters() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let currencyConvertertUrl : String = URLNames.baseUrl + URLNames.currencyConverter
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: currencyConvertertUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        Utility.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let currencyConverterList = jsonValue[APIFields.dataKey]?.array {
                        var currencyConverters = Array<CurrencyConverterModel>()
                        for currencyConverter in currencyConverterList {
                            let currencyConverterModel = CurrencyConverterModel.init(json: currencyConverter)
                            currencyConverters.append(currencyConverterModel)
                        }
                        self.currencyConverters = currencyConverters
                        self.selectedCurrencyConverter = currencyConverters.first ?? CurrencyConverterModel()
                        
                    }
                    DispatchQueue.main.async {
                        self.setPickerDataSourceDelegate(dataSourceArray: self.currencyConverters.map{$0.currencyConverterCountry})
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
    private func getFee(amount:String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let transferListUrl : String = URLNames.baseUrl + URLNames.transferFee
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            let params = [
                "amount": amount,
            ]
            NetworkManager.sharedInstance.commonApiCall(url: transferListUrl, method: .post, parameters: params,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        Utility.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let _ = jsonValue[APIFields.dataKey] {
                        self.feeObj = FeeModel.init(json: jsonValue[APIFields.dataKey]!)
                    }
                    DispatchQueue.main.async {
                        let amountDouble = Double(amount)
                        self.feeAmountValue.text = "\(self.feeObj.feeValue)\(self.selectedCurrencyConverter.currencyConverterBaseCurrency)"
                        let total = ((amountDouble ?? 0.0) * (Double(self.selectedCurrencyConverter.currencyConverterRate) ?? 0.0))
                        self.totalCostValue.text = "\(String(format: "%.2f", total))\(self.selectedCurrencyConverter.currencyConverterCountryCurrency)"
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
