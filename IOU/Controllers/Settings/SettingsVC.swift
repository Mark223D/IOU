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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos:.userInteractive).async {
            DispatchQueue.main.async {
                let firebase = NetworkHandler()
                
                firebase.getSignedInUser { (tempUser) in
                    firebase.getUser(tempUser.uid) { (user) in
                        if let firstName = user.firstName,
                            let lastName = user.lastName
                        {
                            self.usernameLabel.text = "\(firstName) \(lastName)"
                    }
                }
            }
        }
        
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
        let cell: FriendsCell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .green
        
        cell.avatarImageView.backgroundColor = .clear
        
        if indexPath.row == 0{
            cell.nameLabel.text = "Account"
           if #available(iOS 13.0, *) {
                          cell.avatarImageView.image = UIImage(systemName: "person.circle.fill")
            cell.avatarImageView.tintColor = .green
                      } else {
                          // Fallback on earlier versions
                      }
        }
        else{
            cell.nameLabel.text = "Sign Out"
            if #available(iOS 13.0, *) {
                cell.avatarImageView.image = UIImage(systemName: "xmark.circle.fill")
                cell.avatarImageView.tintColor = .green

            } else {
                // Fallback on earlier versions
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height / 3
        
    }
    
    
}


extension SettingsVC {
    
    func initUI(){
        
        self.tabBarItem.image = UIImage(named: "settings")

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        self.tableView.isScrollEnabled = false
        
        self.avatarImageView.maskCircle()
        
//        qrCodeImageView.backgroundColor = .green
        
        self.qrCodeImageView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 20, borderColor: .clear, borderWidth: 10)
        
        
    }
}
