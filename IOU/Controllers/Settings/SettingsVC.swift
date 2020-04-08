//
//  SettingsVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/6/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: MainVC {
  
  var user: User!
  var ref: DatabaseReference!
  
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.initUI()
    self.tabBarItem.image = UIImage(named: "settings")
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if traitCollection.userInterfaceStyle == .light {
      print("Light mode")
      self.tabBarItem.selectedImage = UIImage(named: "settings-active-blue")
    } else {
      print("Dark mode")
      self.tabBarItem.selectedImage = UIImage(named: "settings-active-white")
      
    }
  }
  
}

extension SettingsVC: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.row {
    case 0:
      break
    //            self.performSegue(withIdentifier: "toAccountSettings", sender: self)
    case 1:
      do {
        try Auth.auth().signOut()
        self.performSegue(withIdentifier: "toSignOut", sender: self)
        print("Sign Out Successful")
      } catch let error {
        assertionFailure("Error signing out: \(error)")
      }
    default:
      break
      
    }
  }
}

extension SettingsVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SettingsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
    
    cell.tintColor = .white //UIColor.appColor(.highlight)
    
    cell.avatarImageView.backgroundColor = .clear
    
    if indexPath.row == 0{
      cell.nameLabel.text = "Account"
      cell.avatarImageView.setIcon(icon: .fontAwesomeSolid(.userCog), textColor: .white, size: cell.avatarImageView?.layer.preferredFrameSize())
      
    }
    else{
      cell.nameLabel.text = "Sign Out"
      
      cell.avatarImageView.setIcon(icon: .fontAwesomeSolid(.signOutAlt), textColor: .white, size: cell.avatarImageView?.layer.preferredFrameSize())
 
      
    }
    
    cell.avatarImageView.clipsToBounds = true
     
    return cell

  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.tableView.frame.height/5
  }
  
  
}


extension SettingsVC {
  
  func initUI(){
    
    self.tabBarItem.image = UIImage(named: "settings")
    
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    self.tableView.isScrollEnabled = true
    
    
    //        qrCodeImageView.backgroundColor = .green
    
    
    
  }
}
