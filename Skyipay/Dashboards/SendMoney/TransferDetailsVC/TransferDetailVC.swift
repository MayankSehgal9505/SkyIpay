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
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
    }
    //MARK:- Local Variables
    private let userInfo = UserData.sharedInstance
    private let cp = CountryPickerView()
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
        userInfo.selectedTab = .recipient
        subVCdelegate?.continueButtonTapped()
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
        self.countryLbl.text = country.countryName
        payOutCurrencyValue.text = country.countryCurrency
     }
 }
