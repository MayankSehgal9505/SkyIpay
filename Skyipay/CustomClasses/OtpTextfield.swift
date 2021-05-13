//
//  OtpTextfield.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import Foundation
import UIKit
class OTPTextField: UITextField {
  weak var previousTextField: OTPTextField?
  weak var nextTextField: OTPTextField?
  override public func deleteBackward(){
    text = ""
    previousTextField?.becomeFirstResponder()
   }
}
