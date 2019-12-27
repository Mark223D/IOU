//
//  View_Extensions.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        setGradientBackgroundCustom(colorTop: colorTop, colorBottom: colorBottom, xBottom: 0.0, yBottom: 1.0, xTop: 0.0, yTop: 1.0)
    }
    
    
    func setGradientBackgroundCustom(colorTop: UIColor, colorBottom: UIColor,
                                     xBottom: CGFloat, yBottom: CGFloat,
                                     xTop: CGFloat, yTop: CGFloat) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.darkGrey.cgColor, UIColor.mediumGrey.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

