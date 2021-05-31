//
//  BankDepositDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class BankDepositDetailVC: SendMoneySuperVC {
    //MARK:- IBOutlets 
    @IBOutlet weak var bankLbl: UILabel!
    @IBOutlet weak var bankIdLbl: UILabel!
    @IBOutlet weak var pickersParentView: UIView!
    @IBOutlet weak var bankPickerView: UIPickerView!
    @IBOutlet weak var bankAccountNumTxtFld: UITextField!
    //MARK:- Properties
    private let userInfo = UserData.sharedInstance
    //MARK:- Local Variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private var banks = [Bank]()
    private var selectedBank = Bank()
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        getBankList()
    }
    //MARK:- Internal Methods
    /// set picker data source & delegates
    /// - Parameter dataSourceArray: data source array
    private func setPickerDataSourceDelegate(dataSourceArray:Array<String>) {
        pickerDataSource = GenericPickerDataSource(withItems: dataSourceArray)
        bankPickerView.dataSource = pickerDataSource
        bankPickerView.delegate = pickerDataSource
        pickerDataSource?.delegate = self
        bankPickerView.reloadAllComponents()
    }
    /// Hiding Picker View
    private func hidePickerView(){
        pickersParentView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    private func clearBankData() {
        selectedBank = Bank()
        bankLbl.text = ""
        bankIdLbl.text = ""
        bankAccountNumTxtFld.text = ""
    }
    //MARK:- IBActions    
    @IBAction func removeBankAction(_ sender: UIButton) {
        clearBankData()
    }
    @IBAction func bankBtnTapped(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickersParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickersParentView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickersParentView, view: (self.parent?.view)!)
    }
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func pickerDoneAction(_ sender: UIBarButtonItem) {
        bankLbl.text = selectedBank.bankName
        bankIdLbl.text = "\(selectedBank.bankID)"
        hidePickerView()
    }
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (bankLbl.text?.isEmpty ??  true) {
            self.view.makeToast("Select Bank", duration: 3.0, position: .center)
        } else if (bankIdLbl.text?.isEmpty ??  true) {
            self.view.makeToast("Bank ID can't bee empty", duration: 3.0, position: .center)
        } else if (bankAccountNumTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Bank Account Number can't be empty", duration: 3.0, position: .center)
        } else {
            userInfo.selectedTab = .additional
            subVCdelegate?.continueButtonTapped()
        }
    }
}

//MARK:- GenericPickerDataSourceDelegate Methods
extension BankDepositDetailVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        if let bank = banks.filter({$0.bankName == item}).first {
            selectedBank =  bank
        }
    }
}
//MARK:- API Call Methods
extension BankDepositDetailVC {
    private func getBankList() {
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
                        self.setPickerDataSourceDelegate(dataSourceArray: self.banks.map{$0.bankName})
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
