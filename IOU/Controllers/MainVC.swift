//
//  MainVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/16/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase


class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    
    
    func format(_ amount: Int) -> String?{
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount))
    }
    
    
    
}
