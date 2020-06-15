//
//  IOUHomeCards.swift
//  IOU
//
//  Created by Mark Debbane on 11/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HomeCard: UIView {
  @IBInspectable var cornerRadius:CGFloat = 180 {
        didSet{
          self.layer.cornerRadius = self.cornerRadius
            setupView()
        }
    }
    
   
    func setupView(){
      self.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMaxYCorner, ], radius: self.frame.height/2.4, borderColor: UIColor.appColor(.tabBarSelected) ?? .green, borderWidth: 3)
       }
       override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           setupView()
       }
       override func awakeFromNib() {
           setupView()
       }
    
}
