//
//  BaseTabVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 19/04/21.
//

import UIKit
import RESideMenu
class BaseTabVC: UIViewController {
    
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
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        let leftBarBtnItem : UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"SideMenu"), style: .plain, target: self, action: #selector(presentLeftMenuViewController))
        self.tabBarController?.navigationItem.leftBarButtonItem = leftBarBtnItem
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.tabBarController?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.navigationController?.view.backgroundColor = .clear
    }
    
    /// Function to be called to enable right bar button item
    /// - Parameter imageName: name of image to be used as button icon
    @objc func enableRightBtn() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        //Adding Right bar button
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "homeIcon"), style: .plain, target: self, action: #selector(rightButtonAction))
        rightBarButtonItem.tintColor = UIColor.white
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /// Set navigation title and subtitle
    /// - Parameters:
    ///   - navigationTitle: Navigation bar title
    ///   - subtitle: Navigation bar subtitle
    func setTitle(navigationTitle:String) {
        self.tabBarController?.navigationItem.title = navigationTitle
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
     
    
    /// Right bar button item action, used after overriding in subclass
    @objc func rightButtonAction()  {
        self.tabBarController?.selectedIndex = 2
    }

}
