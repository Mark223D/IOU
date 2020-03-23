//
//  IOUTextField.swift
//  IOU
//
//  Created by Mark on 7/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

@IBDesignable
class IOUTextField: UITextField {
    
    @IBInspectable var insetX: CGFloat = 5
    @IBInspectable var insetY: CGFloat = 0
    @IBInspectable var isSecure: Bool = false
    @IBInspectable var placeholderText: String = ""
    var bottomBar:UIView?
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
      self.tintColor = UIColor.appColor(.tabBarSelected)
      self.textColor = UIColor.appColor(.tabBarSelected)
        self.isSecureTextEntry = isSecure
        
        self.textAlignment = .right
        
        self.minimumFontSize = 20
        
      self.attributedPlaceholder = NSAttributedString(string: placeholderText,attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.tabBarSelected) ?? .green])
        
        
        bottomBar = UIView(frame: CGRect(x: self.frame.origin.x-38, y: self.frame.height, width: self.frame.width, height: 1))
      bottomBar?.backgroundColor = UIColor.appColor(.tabBarSelected)
//        self.addSubview(bottomBar!)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func isEmpty() -> Bool {
        if self.text == "" {
            return true
        }
        return false
    }
}
