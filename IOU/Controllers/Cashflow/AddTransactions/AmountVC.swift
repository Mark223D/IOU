//
//  AmountVC.swift
//  IOU
//
//  Created by Mark Debbane on 5/7/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit

class AmountVC: MainVC {
  
  @IBOutlet weak var switchControl: UISegmentedControl!
  
  @IBOutlet weak var amountValue: UITextField!
  var gave: Bool = true
  
  var transaction: Transaction?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    transaction = Transaction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    amountValue.becomeFirstResponder()
    let nh = NetworkHandler()
    if let amount = self.transaction?.amount{
      self.amountValue.text = "\(amount/1000)"
      
      if let giver = self.transaction?.giver{
        if giver == nh.currentUser?.uid {
          // User is the giver
          self.switchControl.selectedSegmentIndex = 0
          gave = true
        }
        
      }
      else {
          // User is the taker
          self.switchControl.selectedSegmentIndex = 1
          gave = false
        }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toUsers"{
      
      transaction?.amount = (Int((self.amountValue.text ?? "")) ?? 0 ) * 1000
      
      let nh = NetworkHandler()
      
      if gave {
        // User is giver
        
        transaction?.giver = nh.currentUser?.uid
      }
      else{
        // User is taker
        
        transaction?.receiver = nh.currentUser?.uid
      }
      
      let vc: UsersVC = segue.destination as! UsersVC
      vc.transaction = self.transaction
    }
  }
  
  @IBAction func gaveTook(_ sender: Any) {
    let nh = NetworkHandler()
    let message = "\(nh.currentUser?.uid ?? "error") is the "
    if switchControl.selectedSegmentIndex == 0 {
      gave = true
      print("\(message) giver.")
    }
    else{
      gave = false
      print("\(message) taker.")
    }
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    let tabbar = self.tabBarController as! IOUTabBarCtrl
    tabbar.leaveAdd()
    
  }
  
  
  
}


