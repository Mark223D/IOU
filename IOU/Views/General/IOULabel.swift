//
//  IOULabel.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

@IBDesignable
class IOULabel: UILabel{

    func setupView(){
        self.shadowColor = UIColor.shadowColor
        self.shadowOffset = CGSize(width: 0, height: 4)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    override func awakeFromNib() {
        setupView()
    }
}
