//
//  BeneficiariesVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 05/05/21.
//

import UIKit
import CountryPickerView

class BeneficiariesVC: BaseViewController {
    //MARK:- enums
    //MARK:- IBOutlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var beneficiariesTBView: UITableView!
    // add beneficiary PopUp
    @IBOutlet weak var addBeneficiaryBaseView: UIView!
    @IBOutlet weak var addBeneficiaryPopUp: UIView! {didSet {
        addBeneficiaryPopUp.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 8.0)
        addBeneficiaryPopUp.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
    }}
    @IBOutlet weak var mobileNumView: UIView!{didSet {
        mobileNumView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryNameView: UIView!{didSet {
        beneficiaryNameView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryBankNameView: UIView!{didSet {
        beneficiaryBankNameView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryAccountNumView: UIView!{didSet {
        beneficiaryAccountNumView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryEmailView: UIView!{didSet {
        beneficiaryEmailView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryDOBView: UIView!{didSet {
        beneficiaryDOBView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    @IBOutlet weak var beneficiaryCountryView: UIView!{ didSet {
        beneficiaryCountryView.makeCircularView(withBorderColor: Color.silver, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 23)
    }}
    
    @IBOutlet weak var beneficiaryMobileNumTxtFld: UITextField!
    @IBOutlet weak var beneficiaryNameTxtFld: UITextField!
    @IBOutlet weak var beneficiaryBankNameTxtfld: UITextField!
    @IBOutlet weak var beneficiaryAccNoTxtFld: UITextField!
    @IBOutlet weak var beneficiaryEmailTxtFld: UITextField!
    @IBOutlet weak var beneficiaryDOBTxtFld: UITextField!
    @IBOutlet weak var beneficiaryCountryTxtFld: UITextField!
    @IBOutlet weak var beneficiaryDialCode: UILabel!
    @IBOutlet weak var dobPickerMainView: UIView!
    @IBOutlet weak var dobPickerView: UIDatePicker!
    @IBOutlet weak var noBeneficiaryListLbl: UILabel!
    //MARK:- Local Variables
    private let user = UserData.sharedInstance
    private var effectView,vibrantView : UIVisualEffectView?
    private var beneficiaries = [BeneficiaryModel]()
    private let cp = CountryPickerView()
    private var countryModel = Country() {didSet {setupData()}}
    private var dob = ""
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getBeneficiariesList()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func setUpUI(){
        self.setTitle(navigationTitle: "Beneficiaries")
        enableLeftBtn(withIcon: "leftArrow")
        setupTableView()
        setupCountryPicker()
        dobPickerView.maximumDate = Date()
    }
    private func setupCountryPicker() {
        cp.hostViewController = self
        cp.dataSource = self
        cp.delegate = self
        countryModel = cp.selectedCountry
    }
    private func setupTableView() {
        beneficiariesTBView.register(UINib.init(nibName: "BeneficiaryTVC", bundle: nil), forCellReuseIdentifier: "BeneficiaryTVC")
        beneficiariesTBView.tableFooterView = UIView()
        beneficiariesTBView.estimatedRowHeight = 80
        beneficiariesTBView.rowHeight = UITableView.automaticDimension
        beneficiariesTBView.dataSource = self
        beneficiariesTBView.delegate = self
    }
    private func showAddBeneficiaryPopup() {
        self.addBeneficiaryBaseView.isHidden = false
        setupData()
        self.view.bringSubviewToFront(addBeneficiaryBaseView)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    private func setupData() {
        beneficiaryDialCode.text = "+\(countryModel.countryDialCode)"
        beneficiaryCountryTxtFld.text = countryModel.countryName
    }
    private func hideBeneficiaryPopup() {
        clearPopUPData()
        self.addBeneficiaryBaseView.isHidden = true
        self.view.sendSubviewToBack(addBeneficiaryBaseView)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    private func setDate(date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dob = dateFormatter.string(from: date)
    }
    /// Hiding Picker View
    private func hidePickerView(){
        dobPickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    private func clearPopUPData() {
        self.view.endEditing(true)
        beneficiaryMobileNumTxtFld.text = ""
        beneficiaryNameTxtFld.text = ""
        beneficiaryBankNameTxtfld.text = ""
        beneficiaryAccNoTxtFld.text = ""
        beneficiaryEmailTxtFld.text = ""
        beneficiaryDOBTxtFld.text = ""
        countryModel = cp.selectedCountry
        beneficiaryDialCode.text = "+\(countryModel.countryDialCode)"
        beneficiaryCountryTxtFld.text = countryModel.countryName
    }
    //MARK:- IBActions
    override func leftButtonAction() {
        Utility.appDelegate.window?.rootViewController = user.rootVC
    }
    
    @IBAction func addBeneficiaryPopupBtnAction(_ sender: UIButton) {
        if (beneficiaryMobileNumTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Mobile number can't be empty", duration: 3.0, position: .center)
        } else if (beneficiaryNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Name can't be empty", duration: 3.0, position: .center)
        } else if (beneficiaryBankNameTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Bank Name can't be empty", duration: 3.0, position: .center)
        } else if (beneficiaryAccNoTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Account Number can't be empty", duration: 3.0, position: .center)
        }else if (beneficiaryEmailTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(beneficiaryEmailTxtFld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else if (beneficiaryDOBTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Date of Birth can't be empty", duration: 3.0, position: .center)
        } else if (beneficiaryCountryTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Country can't be empty", duration: 3.0, position: .center)
        } else {
            addBeneficiaryCall()
        }
    }
    @IBAction func addBeneficiaryCrossAction(_ sender: UIButton) {
        hideBeneficiaryPopup()
    }
    @IBAction func addBeneficiaryAction(_ sender: UIButton) {
        showAddBeneficiaryPopup()
    }
    
    @IBAction func countryBtnAction(_ sender: UIButton) {
        cp.showCountriesList(from: self)
    }
    
    @IBAction func dobBtnAction(_ sender: UIButton) {
        setDate(date: Date())
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(dobPickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.dobPickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: dobPickerMainView, view: self.view)
    }
    
    @IBAction func cacelPickerViewAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func donePickerViewAction(_ sender: UIBarButtonItem) {
        beneficiaryDOBTxtFld.text = dob
        hidePickerView()
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        setDate(date: sender.date)
   }
    
}

// MARK: API Call
extension BeneficiariesVC {
    private func removeBeneficiary(beneficiaryModel:BeneficiaryModel) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let updateUserProfileUrl = URLNames.baseUrl + URLNames.removeBeneficiary
            let parameters = [
                "id":beneficiaryModel.beneficiaryID,
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
                    self.hideBeneficiaryPopup()
                    self.getBeneficiariesList()
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
    
    private func getBeneficiariesList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = URLNames.baseUrl + URLNames.beneficiaryList
            let headers = [
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .get, parameters: nil,headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
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
                    }
                    DispatchQueue.main.async {
                        self.beneficiariesTBView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.beneficiariesTBView.isHidden = self.beneficiaries.count == 0
                    self.noBeneficiaryListLbl.isHidden = !self.beneficiariesTBView.isHidden
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    private func addBeneficiaryCall(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let updateUserProfileUrl = URLNames.baseUrl + URLNames.addBeneficiary
            let parameters = [
                "name":beneficiaryNameTxtFld.text!,
                "email":beneficiaryEmailTxtFld.text!,
                "dial_code":"\(countryModel.countryDialCode)",
                "phone":beneficiaryMobileNumTxtFld.text!,
                "dob":beneficiaryDOBTxtFld.text!,
                "ac_no":beneficiaryAccNoTxtFld.text!,
                "bank_name":beneficiaryBankNameTxtfld.text!,
                "country_id":"\(countryModel.countryId)",
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
                    self.hideBeneficiaryPopup()
                    self.getBeneficiariesList()
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

// MARK: API Call
extension BeneficiariesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beneficiaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeneficiaryTVC", for: indexPath) as! BeneficiaryTVC
        cell.setupCell(beneficiaries[indexPath.row])
        return cell
    } 
}

// MARK: API Call
extension BeneficiariesVC: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beneficiaryDetailVC = BeneficiaryDetailVC()
        beneficiaryDetailVC.beneficiaryModel = beneficiaries[indexPath.row]
        self.navigationController?.pushViewController(beneficiaryDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
            // Write action code for the Deleting beneficiary
        let trashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.removeBeneficiary(beneficiaryModel: self.beneficiaries[indexPath.row])
            success(true)
        })
        trashAction.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [trashAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

//MARK:- CountryPickerViewDataSource & CountryPickerViewDelegateMethods
extension BeneficiariesVC: CountryPickerViewDataSource, CountryPickerViewDelegate {
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
        countryModel = country
     }
 }
