//
//  SendMoneyNavigator.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 29/05/21.
//

import Foundation
import UIKit
protocol SendMoneySuperVCNavigator: class {
    func continueButtonTapped()
}
class SendMoneySuperVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var continueBtn: CustomButton!{
        didSet {
            continueBtn.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: false)
        }
    }
    //MARK:- Properties
    var subVCdelegate: SendMoneySuperVCNavigator?
}


class ViewEmbedder {
    static let userInfo = UserData.sharedInstance
    class func embed(parent:UIViewController,container:UIView,child:UIViewController,childClassName:String,previous:UIViewController?){
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        var childVC = child
        if let existingChild = userInfo.cachedControllers.filter({ (controllerDict) -> Bool in
            return controllerDict.keys.contains(childClassName)
        }).first {
            childVC = existingChild[childClassName] ?? UIViewController()
        } else {
            let controllerDict = [childClassName:child]
            userInfo.cachedControllers.append(controllerDict)
        }
        childVC.willMove(toParent: parent)
        parent.addChild(childVC)
        container.addSubview(childVC.view)
        childVC.didMove(toParent: parent)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        childVC.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }

    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc, childClassName: "",
            previous: parent.children.first
        )
        completion?(vc)
    }
}

class SendMoneyNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
