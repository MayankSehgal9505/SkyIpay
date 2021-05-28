//
//  RecipientsVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//
import UIKit
class SendMoneyTabView: UIView {
    
    var contentView : UIView!
    let nibName = "SendMoneyTabView"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    /// Adds the contentview of xib to self and adjust its frames according to self
    func xibSetUp() {
        contentView = loadViewFromNib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
    }
    
    /// Returns the content view of xib to which self is the file owner
    ///
    /// - Returns: content view of xib
    func loadViewFromNib() ->UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    




}

