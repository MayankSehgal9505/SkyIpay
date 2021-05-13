//
//  CommonMethods.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 21/04/21.
//

import Foundation
import UIKit
class CommonMethods {
    /// Check If Device is iPad
    class func isDeviceiPad() -> Bool {
        return (UI_USER_INTERFACE_IDIOM() == .pad)
    }
    
    class func showPopUpWithVibrancyView(on controller: Any) -> Array<UIView> {
        var vibrantView = UIVisualEffectView()
        var effectView = UIVisualEffectView()
        let blur = UIBlurEffect(style: .dark)
        // create vibrancy effect
        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        // add blur to an effect view
        effectView = UIVisualEffectView(effect: blur)
        // add vibrancy to yet another effect view
        vibrantView = UIVisualEffectView(effect: vibrancy)
        effectView.alpha = 0.6
        vibrantView.alpha = 0.3
        var vibrancyAdded = false
        // don't add vibrantView & effectView on window if window is nil
        if(((controller as AnyObject).isKind(of: UIViewController.self)) && (controller as? UIViewController)?.view.window != nil) {
            (controller as? UIViewController)?.view.window?.addSubview(vibrantView)
            (controller as? UIViewController)?.view.window?.addSubview(effectView)
            vibrancyAdded = true
        } else if(((controller as AnyObject).isKind(of: UIView.self)) && (controller as? UIView)?.window != nil) {
            (controller as? UIView)?.window?.addSubview(vibrantView)
            (controller as? UIView)?.window?.addSubview(effectView)
            vibrancyAdded = true
        }
        if (vibrancyAdded) {
            // set effectview & vibrat view constraits w.r.t uiwindow
            effectView.setConstraintOfView(withRespectTo: (UIApplication.shared.delegate as! AppDelegate).window!)
            vibrantView.setConstraintOfView(withRespectTo: (UIApplication.shared.delegate as! AppDelegate).window!)
        }
        return [vibrantView,effectView]
    }
    
    class func setPickerConstraintAccordingToDevice(pickerView:UIView,view:UIView){
        pickerView.translatesAutoresizingMaskIntoConstraints = !self.isDeviceiPad()
        if(self.isDeviceiPad()){
            pickerView.bottomAnchor.constraint(equalTo: view.window?.bottomAnchor ?? view.bottomAnchor).isActive = true
            pickerView.leftAnchor.constraint(equalTo: view.window?.leftAnchor ?? view.leftAnchor).isActive = true
            pickerView.rightAnchor.constraint(equalTo: view.window?.rightAnchor ?? view.rightAnchor).isActive = true
        }
        else{
            if let windowHeight = (view.window?.frame.size.height) {
                // setting frame of picker view
                pickerView.frame = CGRect(x: 0, y: windowHeight - pickerView.frame.size.height, width: view.frame.size.width, height: pickerView.frame.size.height)
            }else {
                // setting frame of picker view
                pickerView.frame = CGRect(x: 0, y: view.frame.size.height - pickerView.frame.size.height, width: view.frame.size.width, height: pickerView.frame.size.height)
            }
        }
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        if (email.contains("..")) {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
