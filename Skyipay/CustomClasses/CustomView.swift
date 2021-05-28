//
//  CustomView.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 27/05/21.
//

import Foundation
import UIKit
@IBDesignable

final class CustomView: UIButton {
    

    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var customBorderColor: UIColor = UIColor.blue{
        didSet {
            self.layer.borderColor = customBorderColor.cgColor
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.white{
        didSet {
            self.backgroundColor = fillColor
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.blue{
        didSet {
            self.setTitleColor(textColor,for: .normal)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.borderColor = customBorderColor.cgColor
    }
}
