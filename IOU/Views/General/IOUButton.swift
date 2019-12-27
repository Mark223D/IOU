//
//  IOUButton.swift
//  IOU
//
//  Created by Mark on 7/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class IOUButton: UIButton {
    @IBInspectable var titleText: String = "" {
        didSet{
            let range = (titleText as NSString).range(of: titleText)

            let attribute = NSMutableAttributedString.init(string: titleText)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)

            self.setAttributedTitle(attribute, for: .normal)
            self.titleLabel?.text = titleText
            self.titleLabel?.textColor = UIColor.white
            
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.white {
        didSet{
            self.tintColor = fontColor
            
        }
    }
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.green
        self.layer.cornerRadius = cornerRadius
        self.addTarget(self, action: #selector(scaleToSmall), for: .touchDown)
        self.addTarget(self, action: #selector(scaleToSmall), for: .touchDragEnter)
        self.addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
        self.addTarget(self, action:#selector(scaleDefault), for: .touchDragExit)
        
  
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    @objc func scaleToSmall(){
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 0.95, height: 0.95))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    @objc func scaleAnimation(){
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        scaleAnim?.springBounciness = 10
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
        
    }
    
    @objc func scaleDefault(){
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringDefaultAnimation")
    }
}
