//
//  CustomPageControl.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 17/04/21.
//

import UIKit

class CustomPageControl: UIPageControl {

    var indicators: [UIView] = []

    override var numberOfPages: Int {
        didSet {
            updateIndicators()
        }
    }

    override var currentPage: Int {
        didSet {
            updateIndicators()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }

    private func updateIndicators() {
        if #available(iOS 14.0, *) {
           indicators = self.subviews.first?.subviews.first?.subviews ?? []
        } else {
           indicators = self.subviews
        }
         for (index, indicator) in indicators.enumerated() {
            // remove existing subviews from indicator view
            for subview in indicator.subviews {
                subview.removeFromSuperview()
            }
            // add new subviews
            let image = self.currentPage == index ? UIImage.init(named: "CurrentPageIndicator") : UIImage.init(named: "UnSelectedPageIndicator")
            if let dot = indicator as? UIImageView {
                dot.image = image
            } else {
                let imageView = UIImageView.init(image: image)
                indicator.addSubview(imageView)
            }
         }
     }
}
