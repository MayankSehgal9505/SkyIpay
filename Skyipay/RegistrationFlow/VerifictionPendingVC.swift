//
//  VerifictionPendingVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 23/04/21.
//

import UIKit

class VerifictionPendingVC: UIViewController,LogOutCall {

    //MARK:- IBOutlets
    @IBOutlet weak var baseView: UIView!
    
    //MARK:- Local variables
    private var timer : Timer?
    private var timelimit = 0

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        //initializeTimer()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Call the roundCorners() func right there.
        baseView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Internal Methods
    private func initializeTimer() {
        timelimit = 3
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    
    @objc private func startTimer() {
        if timelimit == 0 {
            timer?.invalidate()
            timer = nil
            moveToVerificationDoneVC()
        } else {
            timelimit = timelimit-1
        }
    }
    
    private func moveToVerificationDoneVC() {
        let verificationDone = VerificationDoneVC()
        self.navigationController?.pushViewController(verificationDone, animated: true)
    }
    
    private func logout() {
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let logoutButton = UIAlertAction(title: "Logout", style: .default) { _ in
            self.callLogOutApi()
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        logOutAlert.addAction(logoutButton)
        logOutAlert.addAction(cancelButton)
        self.present(logOutAlert, animated: true, completion: nil)
    }
    
    //MARK:- IBActions
    
    @IBAction func logoutAction(_ sender: UIButton) {
        logout()
    }
}
