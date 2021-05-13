//
//  UIView.swift
//  Skyipay
//
//  Created by Mayank Sehgal on 17/04/21.
//

import Foundation
import UIKit
import Toast_Swift
extension UIView {
    /// Make View Circular with passed border color
    ///
    /// - Parameter borderColor: border color of circle
    /// - Parameter borderWidth: border width of circle
    func makeCircularView(withBorderColor color: UIColor, withBorderWidth borderWidth: CGFloat = 1.0, withCustomCornerRadiusRequired cornerRadiusRequired:Bool = false, withCustomCornerRadius cornerRadius: CGFloat = 6.0) {
        self.layer.cornerRadius = cornerRadiusRequired ? cornerRadius : (self.frame.size.width / 2)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    
    func setConstraintOfView(withRespectTo parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true,setPath: Bool = false) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        if setPath {
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

