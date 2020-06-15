//
//  UsersVC.swift
//  IOU
//
//  Created by Mark Debbane on 5/7/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {
  var transaction: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()
navigationController?.delegate = self
        // Do any additional setup after loading the view.
    }
    

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let am = self.transaction?.amount {
      print(am)
    }
  }
}

extension UsersVC: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let transaction = self.transaction {
         (viewController as? AmountVC)?.transaction = transaction // Here you pass the to your original view controller
    }
     }
}
