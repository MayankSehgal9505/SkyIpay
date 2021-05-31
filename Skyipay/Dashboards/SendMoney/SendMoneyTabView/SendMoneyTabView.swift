//
//  RecipientsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//
import UIKit
enum Tabs: Int {
    case transfer = 0
    case recipient, bankDeposit, additional, paymment, review,reset
    
    var associatedClass:String {
        switch self {
            case .transfer: return "TransferDetailVC"
            case .recipient: return "RecepientDetailsVC"
            case .bankDeposit: return "BankDepositDetailVC"
            case .additional: return "AdditionalDetailVC"
            case .paymment: return "PaymentDetailVC"
            case .review: return "ReviewVC"
            default: return  ""
        }
    }
}
protocol SendMoneyTabProtocol: class{
    func tabBtnTapped()
}
class SendMoneyTabView: UIView {
    //MARK:- IBOutlets
    @IBOutlet var tabBtns: [UIButton]!
    @IBOutlet var tabsImgs: [UIImageView]!
    @IBOutlet var tabsLinesView: [UIView]!
    @IBOutlet var tabsLabel: [UILabel]!
    
    //MARK:- Properties
    weak var tabDelegate: SendMoneyTabProtocol?
    //MARK:- Local Variables
    var contentView : UIView!
    let userInfo = UserData.sharedInstance
    //MARK:- Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    //MARK:- Internal Methods

    /// Adds the contentview of xib to self and adjust its frames according to self
    private func xibSetUp() {
        contentView = loadViewFromNib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
        setTags()
    }
    
    /// Returns the content view of xib to which self is the file owner
    ///
    /// - Returns: content view of xib
    private func loadViewFromNib() ->UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: "SendMoneyTabView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // Set tags
    private func setTags() {
        // set tags to buttons
        for (index,_) in tabBtns.enumerated() {
            guard let tabType = Tabs.init(rawValue: index) else {return}
            tabBtns[index].tag = tabType.rawValue
        }
        // set tags to Images
        for (index,_) in tabsImgs.enumerated() {
            guard let tabType = Tabs.init(rawValue: index) else {return}
            tabsImgs[index].tag = tabType.rawValue
        }
        // set tags to Tabs Label
        for (index,_) in tabsLabel.enumerated() {
            guard let tabType = Tabs.init(rawValue: index) else {return}
            tabsLabel[index].tag = tabType.rawValue
        }
        
        // set tags to Tabs Label
        for (index,_) in tabsLinesView.enumerated() {
            guard let tabType = Tabs.init(rawValue: index) else {return}
            tabsLinesView[index].tag = tabType.rawValue
        }
    }
    func resetUI() {
        tabsImgs.forEach { $0.image = UIImage(named: "greyCircle")        }
        tabsLabel.forEach { $0.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0)       }
        tabsLinesView.forEach { $0.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)        }

    }
    func updateUI() {
        tabsImgs.forEach { tabImg in
            if tabImg.tag <= userInfo.selectedTab.rawValue {
                tabImg.image = UIImage(named: "blueCircle")
            } else {
                tabImg.image = UIImage(named: "greyCircle")
            }
        }
        
        tabsLabel.forEach { tabLbl in
            if tabLbl.tag <= userInfo.selectedTab.rawValue {
                tabLbl.textColor = UIColor.init(red: 29/255, green: 0/255, blue: 248/255, alpha: 1.0)
            } else {
                tabLbl.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0)
            }
        }
        
        tabsLinesView.forEach { lineView in
            if lineView.tag < userInfo.selectedTab.rawValue {
                lineView.backgroundColor = UIColor.init(red: 29/255, green: 0/255, blue: 253/255, alpha: 1.0)
            } else {
                lineView.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
            }
        }
    }
    //MARK:- IBActions
    @IBAction func tabBtnClicked(_ sender: UIButton) {
        // if user presss on tab which is not yet visited by user then don't perform any action
        if sender.tag > userInfo.cachedControllers.count-1 {
            return
        } else {
            guard let tabType =  Tabs.init(rawValue: sender.tag) else {return}
            userInfo.selectedTab = tabType
            tabDelegate?.tabBtnTapped()
        }
    }
}

