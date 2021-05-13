//
//  WalkthroughVC.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 16/04/21.
//

import UIKit
class WalkthroughVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    @IBOutlet weak var customPageControl: CustomPageControl!
    
    //MARK:- Local Variables
    private var walkthroughModelArray = Array<WalkThroughModel>()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getModel()
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
        customPageControl.currentPage =  0
        customPageControl.numberOfPages = walkthroughModelArray.count
    }
    
    
    //MARK:- Internal Methods
    /// setup tableView
    private func setupCollectionView() {
        walkThroughCollectionView.register(UINib.init(nibName: "WalkthroughCell", bundle: nil), forCellWithReuseIdentifier: "WalkthroughCell")
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .horizontal
        walkThroughCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    private func getModel() {
        let walkthroughArray = Array(zip(WalkthroughUI.walkthroughImages, zip(WalkthroughUI.titleTexts, WalkthroughUI.descriptionTexts)))
        for walkthroughElement in walkthroughArray {
            let walkThroughModel = WalkThroughModel.init(imageName: walkthroughElement.0, titleText: walkthroughElement.1.0, descriptionText: walkthroughElement.1.1)
            walkthroughModelArray.append(walkThroughModel)
        }
    }
    
    private func updateIndicators() {
         var indicators: [UIView] = []
         
         if #available(iOS 14.0, *) {
            indicators = self.customPageControl.subviews.first?.subviews.first?.subviews ?? []
         } else {
            indicators = self.customPageControl.subviews
         }
         
         for (index, indicator) in indicators.enumerated() {
            let image = self.customPageControl.currentPage == index ? UIImage.init(named: "CurrentPageIndicator") : UIImage.init(named: "UnSelectedPageIndicator")
             if let dot = indicator as? UIImageView {
                 dot.image = image
                 
             } else {
                 let imageView = UIImageView.init(image: image)
                 indicator.addSubview(imageView)
             }
         }
     }

    //MARK:- IBActions
    
    /// Takes user to login screen
    /// - Parameter sender: sender is login btn
    @IBAction func loginBtnAction(_ sender: UIButton) {
        let loginVC = LoginVC()
        loginVC.typeOfScreen = .login
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    /// Takes user to Register Screen
    /// - Parameter sender: sender is Register btn
    @IBAction func resgisterBtnAction(_ sender: UIButton) {
        let registerVC = LoginVC()
        registerVC.typeOfScreen = .register
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}
//MARK:- UICollectionViewDataSource Methods
extension WalkthroughVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walkthroughModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let walkThroughCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCell", for: indexPath) as! WalkthroughCell
        walkThroughCell.setupCell(walkthroughModel: walkthroughModelArray[indexPath.item])
        return walkThroughCell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
extension WalkthroughVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}

extension WalkthroughVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        customPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
}

    
}


