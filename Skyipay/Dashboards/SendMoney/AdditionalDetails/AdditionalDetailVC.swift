//
//  AdditionalDetailVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 28/05/21.
//

import UIKit

class AdditionalDetailVC: SendMoneySuperVC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var pickersParentView: UIView!
    @IBOutlet weak var transferPickerView: UIPickerView!
    @IBOutlet weak var transferReasonBtn: UIButton!
    @IBOutlet weak var reasonForTransferLbl: UILabel!
    //MARK:- Properties
    private let userInfo = UserData.sharedInstance
    //MARK:- Local Variables
    private var effectView,vibrantView : UIVisualEffectView?
    private var pickerDataSource: GenericPickerDataSource?
    private var transferReasons = [TransferReasonModel]()
    private var selectedReason = TransferReasonModel()
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReasonsList()
    }
    //MARK:- Internal Methods
    /// set picker data source & delegates
    /// - Parameter dataSourceArray: data source array
    private func setPickerDataSourceDelegate(dataSourceArray:Array<String>) {
        pickerDataSource = GenericPickerDataSource(withItems: dataSourceArray)
        transferPickerView.dataSource = pickerDataSource
        transferPickerView.delegate = pickerDataSource
        pickerDataSource?.delegate = self
        transferPickerView.reloadAllComponents()
    }
    /// Hiding Picker View
    private func hidePickerView(){
        pickersParentView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    //MARK:- IBActions
    
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func pickerDoneAction(_ sender: UIBarButtonItem) {
        reasonForTransferLbl.text = selectedReason.reasonTitle
        hidePickerView()
    }
    @IBAction func transferBtnAction(_ sender: UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickersParentView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickersParentView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickersParentView, view: (self.parent?.view)!)
    }
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(false)
        if (reasonForTransferLbl.text?.isEmpty ??  true) {
            self.view.makeToast("Select reason for transfer", duration: 3.0, position: .center)
        } else {
            userInfo.selectedTab = .paymment
            subVCdelegate?.continueButtonTapped()
        }
    }
}

//MARK:- GenericPickerDataSourceDelegate Methods
extension AdditionalDetailVC: GenericPickerDataSourceDelegate {
    func selected(item: String) {
        if let selectedTransferReason = transferReasons.filter({$0.reasonTitle == item}).first {
            selectedReason =  selectedTransferReason
        }
    }
}

//MARK:- API Call Methods
extension AdditionalDetailVC {
    private func getReasonsList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            Utility.showHUDOnWindow(progressLabel: AlertField.loaderString)
            let transferListUrl : String = URLNames.baseUrl + URLNames.transferReason
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
                    if let transferReasonList = jsonValue[APIFields.dataKey]?.array {
                        var transferReasons = Array<TransferReasonModel>()
                        for transferReason in transferReasonList {
                            let transferReasonModel = TransferReasonModel.init(json: transferReason)
                            transferReasons.append(transferReasonModel)
                        }
                        self.transferReasons = transferReasons
                        self.selectedReason = self.transferReasons.first ?? TransferReasonModel()
                    }
                    DispatchQueue.main.async {
                        self.setPickerDataSourceDelegate(dataSourceArray: self.transferReasons.map{$0.reasonTitle})
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

