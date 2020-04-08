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
    self.tabBarController?.tabBar.items?[0].image = UIImage(named: "home")
    self.tabBarController?.tabBar.items?[1].image = UIImage(named: "activity")
    self.tabBarController?.tabBar.items?[3].image = UIImage(named: "friends")
      self.tabBarController?.tabBar.items?[4].image = UIImage(named: "settings")
     
        
    }

    
    
    func format(_ amount: Int) -> String?{
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount))
    }
    
    
    
}
