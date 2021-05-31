//
//  UIViewController.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    /// Showing loader on API call
    ///
    /// - Parameter progressLabel: Loader message
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }

     ///Dismiss loader after API response
    ///
    /// - Parameter isAnimated: animation
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
    
    /// Method to show alert when no internet connection
    func showNoInternetAlert(){
        let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    /// Showing generic alert
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: description of alert
    @objc func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: AlertField.okString, style: .default))
        present(ac, animated: true)
    }


    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    // set Padding Of textfield
       func setPadding(textField: UITextField){
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
           textField.leftViewMode = .always
       }
    
    func setCornerWithColor(aView: UIView, radius:CGFloat){
        aView.makeCircularView(withBorderColor: .clear, withCustomCornerRadiusRequired: true, withCustomCornerRadius: radius)
        aView.layer.borderWidth = 1.0
        aView.layer.borderColor = UIColor(red: 28/255.0, green: 54/255.0, blue: 102/255.0, alpha: 1).cgColor
    }
    
    /**
     go back Alert
     - Show alert with title and alert message and basic two actions
     */
    func showNoDataAlert(message:String) {
        let alert = UIAlertController(title: AlertField.alertString, message: message,         preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertField.okString,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    //Load the UIView using Nibname
    func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    //Check current viewcontroller is presented, Pushed or not
    func isModal() -> Bool {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self {
                return false
            }
        }
        if self.presentingViewController != nil {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    //Get topViewController from UIApllication Window or Current Navigation Controller
    public func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension Utility{
    
    /// Showing loader on API call
    ///
    /// - Parameter progressLabel: Loader message
    class func showHUDOnWindow(progressLabel:String){
        let window = (UIApplication.shared.delegate?.window)!
        let progressHUD = MBProgressHUD.showAdded(to: window!, animated: true)
        progressHUD.label.text = progressLabel
    }

     ///Dismiss loader after API response
    ///
    /// - Parameter isAnimated: animation
    class func dismissHUD(isAnimated:Bool) {
        let window = UIApplication.shared.delegate?.window!
        MBProgressHUD.hide(for: window!, animated: isAnimated)
    }
    
}
