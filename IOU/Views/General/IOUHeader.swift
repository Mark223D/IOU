//
//  IOUHeader.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

@IBDesignable
class IOUHeader: UIView {
    @IBInspectable var cornerRadius:CGFloat = 10.0{
        didSet{
            setupView()
        }
    }
    func setupView(){
        self.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: cornerRadius, borderColor: UIColor.clear, borderWidth: 0)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    override func awakeFromNib() {
        setupView()
    }
}
