//
//  UploadDocumentsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 22/04/21.
//

import UIKit

class UploadDocumentsVC: BaseViewController {
    enum PickerType {
        case idProofType
        case issueDate
        case endDate
    }
    //MARK:- IBOutlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var pickerMainView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerMainView: UIView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet var allSubViews: [UIView]! {
        didSet {
            allSubViews.forEach { view in
                view.makeCircularView(withBorderColor: .clear, withBorderWidth: 0.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
                view.dropShadow(color: .gray, opacity: 0.6, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
            }
        }
    }
    
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var issueDate: UITextField! {
        didSet {
            issueDate.makeCircularView(withBorderColor: .black, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
        }
    }
    @IBOutlet weak var endDate: UITextField!{
        didSet {
            endDate.makeCircularView(withBorderColor: .black, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 10)
        }
    }
    //MARK:- Local Variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private let documentArray = ["Driving License", "Passport", "BRP"]
    private var pickerType: PickerType = .idProofType
    private var selectedItem = ""
    var selecteddate = ""
    var imagedict:[String:Data] = [:]
    private let user = UserData.sharedInstance
    var userModelObj = UserModel()
    //MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(navigationTitle: "Document Verification")
        self.enableLeftBtn(withIcon: "")
        setupInitialUi()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Call the roundCorners() func right there.
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Internal Methods

    private func setupInitialUi(){
        idTextfield.text = documentArray.first!
        setPickerDataSourceDelegate(dataSourceArray: documentArray)
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
        datePickerMainView.isHidden = true
        pickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    private func moveToverification() {
        let verificationVC = VerifictionPendingVC()
        self.navigationController?.pushViewController(verificationVC, animated: true)
    }

    //MARK:- IBActions
    
    @IBAction func chooseIDBtnAction(_ sender: Any) {
        pickerType = .idProofType
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerMainView, view: self.view)
    }    
    
    @IBAction func uploadIdCardBtnAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["id_card"] = data
            }
        }
    }
    @IBAction func uploadBillAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["utility_bills"] = data
            }
        }
    }
    @IBAction func uploadBankStatement(_ sender: UIButton){
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["bank_statements"] = data
            }
        }
    }
    
    @IBAction func sourceOfIncomeUpload(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["source_income"] = data
            }
        }
    }
    
    @IBAction func uploadPaySlips(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["pay_slips"] = data
            }
        }
    }
    
    @IBAction func uploaddob(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            let imageData: Data? = image.jpegData(compressionQuality: 0.5)
            if let data = imageData {
                self.imagedict["dob_proof"] = data
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    
    
    @IBAction func donePickerAction(_ sender: UIBarButtonItem) {
        switch pickerType {
        case .idProofType:
            self.idTextfield.text = selectedItem.lowercased()
        case .issueDate:
            self.issueDate.text = selecteddate
        case .endDate:
            self.endDate.text = selecteddate
        }
        hidePickerView()
    }
    @IBAction func issueDateBtn(_ sender: UIButton) {
        pickerType = .issueDate
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datePickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datePickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datePickerMainView, view: self.view)
    }
    
    @IBAction func endDateBtn(_ sender: UIButton) {
        pickerType = .endDate
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(datePickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.datePickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: datePickerMainView, view: self.view)
    }
    
    @IBAction func datepickerValueChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selecteddate = dateFormatter.string(from: sender.date)
    }
    @IBAction func verifyAction(_ sender: UIButton) {
        /*if (idTextfield.text?.isEmpty ??  true) {
            self.view.makeToast("Choose ID", duration: 3.0, position: .center)
        } else if (issueDate.text?.isEmpty ??  true) {
            self.view.makeToast("Issue date can't be empty", duration: 3.0, position: .center)
        } else if (endDate.text?.isEmpty ??  true) {
            self.view.makeToast("Expire date can't be empty", duration: 3.0, position: .center)
        } else*/
        if imagedict.count<6{
            self.view.makeToast("Upload all documents", duration: 3.0, position: .center)
        } else {
            uploadDocuments()
        }
    }
}
//MARK:- GenericPickerDataSourceDelegate Methods
extension UploadDocumentsVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        selectedItem = item
    }
}
//MARK:- API call
extension UploadDocumentsVC {
    private func uploadDocuments(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let uploadDocumentsUrl : String = URLNames.baseUrl + URLNames.register
            let parameters = [
                "first_name":userModelObj.firstName,
                "last_name":userModelObj.lastname,
                "email":userModelObj.email,
                "password":userModelObj.password,
                "dob":userModelObj.userDOB,
                "iso":userModelObj.userAddress.first?.countryModel.countryISOCode ?? "IN",
                "country_id":userModelObj.userAddress.first?.countryModel.countryId ?? 99,
            ] as [String : Any]
            print(parameters)
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(Defaults.getAccessToken())",
            ]
            NetworkManager.sharedInstance.uploadDocuments(url: uploadDocumentsUrl, method: .post, imagesDict: self.imagedict, parameters: parameters,headers: headers) { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                   self.view.makeToast(status, duration: 3.0, position: .bottom)
                   self.dismissHUD(isAnimated: true)
                   return
                }
                if let apiSuccess = jsonValue[APIFields.codeKey], apiSuccess == 200 {
                    Defaults.setUserLoggedIn(userLoggedIn: true)
                    self.moveToverification()
                }
                else {
                    self.view.makeToast(jsonValue["msg"]?.stringValue, duration: 3.0, position: .bottom)
                }
                self.dismissHUD(isAnimated: true)
            }
        }else{
            self.showNoInternetAlert()
        }
    }
}
