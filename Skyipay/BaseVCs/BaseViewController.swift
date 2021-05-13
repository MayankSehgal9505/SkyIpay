//
//  BaseViewController.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 18/04/21.
//

import UIKit
enum CustomNavigation {
    case required
    case notRequired
}
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        let blackView = UIView.init(frame: self.view.frame)
        blackView.backgroundColor = .black
        blackView.alpha = 0.8
        self.view.insertSubview(blackView, at: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationBar()
    }
    
    /// Setup Navigation bar
    func setNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    /// Function to be called to enable right bar button item
    /// - Parameter imageName: name of image to be used as button icon
    @objc func enableLeftBtn(withIcon imageName:String) {
        //Adding Right bar button
        let leftBarBtnItem : UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named:imageName), style: .plain, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem = leftBarBtnItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    /// Function to be called to enable right bar button item
    /// - Parameter imageName: name of image to be used as button icon
    @objc func enableRightBtn(withIcon imageName:String) {
        //Adding Right bar button
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(rightButtonAction))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /// Set navigation title and subtitle
    /// - Parameters:
    ///   - navigationTitle: Navigation bar title
    ///   - subtitle: Navigation bar subtitle
     func setTitle(navigationTitle:String) {
        self.navigationItem.title = navigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
     
    /// Left bar button item action
    @objc func leftButtonAction()  {
    }
    
    /// Right bar button item action, used after overriding in subclass
    @objc func rightButtonAction()  {
        
    }

}
