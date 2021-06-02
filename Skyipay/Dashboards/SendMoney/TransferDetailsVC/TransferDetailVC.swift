//
//  TransferDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import UIKit
import CountryPickerView

class TransferDetailVC: SendMoneySuperVC {

    //MARK:- IBOutlets
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var payOutCurrencyValue: UILabel!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var feeAmountValue: UILabel!
    @IBOutlet weak var totalCostValue: UILabel!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var moneyWalletBtn: UIButton!
    @IBOutlet weak var bankBtn: UIButton!
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        getFee()
    }
    //MARK:- Local Variables
    private let userInfo = UserData.sharedInstance
    private let sendMoneyInfo = SendMoney.sharedInstance
    private let cp = CountryPickerView()
    private var feeObj = FeeModel()
    private var amountEntered = 0
    private var selectedCoutry = Country()
    //MARK:- Internal Methods
    private func setupInitialUI() {
        setupCountryPicker()
        self.countryLbl.text = userInfo.userModel.userAddress.first?.countryModel.countryName
        payOutCurrencyValue.text = userInfo.userModel.userAddress.first?.countryModel.countryCurrency
    }
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
    }
    //MARK:- IBActions
    @IBAction func contiueAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (countryLbl.text?.isEmpty ??  true) {
            self.view.makeToast("Select Destination Country", duration: 3.0, position: .center)
        } else if (payOutCurrencyValue.text?.isEmpty ??  true) {
            self.view.makeToast("PayOut Currency can't be empty", duration: 3.0, position: .center)
        } else if (amountTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Amount can't be empty", duration: 3.0, position: .center)
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
        guard let transferAmount = sender.text, let amountValue = Int(transferAmount) else {
            return
        }
        if amountValue <= feeObj.minAmount {
            self.feeAmountValue.text = "\(self.feeObj.feeValue)"
            self.totalCostValue.text = sender.text
        } else {
            self.feeAmountValue.text = "00"
            self.totalCostValue.text = "\(amountValue + self.feeObj.feeValue)"
        }
    }
    @IBAction func countryBtnAction(_ sender: UIButton) {
        cp.showCountriesList(from: self)
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

//MARK:- API Call Methods
extension TransferDetailVC {
    private func getFee() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let transferListUrl : String = URLNames.baseUrl + URLNames.getFee
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: transferListUrl, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        Utility.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    if let feeArray = jsonValue[APIFields.dataKey]?.array {
                        if let firstFee = feeArray.first {
                            self.feeObj = FeeModel.init(json: firstFee)
                        }
                    }
                    DispatchQueue.main.async {
                        self.feeAmountValue.text = "\(self.feeObj.feeValue)"
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
