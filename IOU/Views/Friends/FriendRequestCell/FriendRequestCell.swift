//
//  FriendRequestCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/26/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestCell: UITableViewCell {
  
  var model: Friend?
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var declineBtn: UIButton!
  @IBOutlet weak var confirmBtn: UIButton!
  
  
  var friendHandler: FriendHandler = FriendHandler()
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.confirmBtn.titleEdgeInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    self.declineBtn.titleEdgeInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)

    self.userImage.layer.cornerRadius = self.userImage.frame.height/2
    self.userImage.setIcon(icon: .fontAwesomeSolid(.user), textColor: .white, backgroundColor: UIColor.appColor(.highlight) ?? .orange)
    
    
  }
  
  func setModel(_ model: Friend){
    self.model = model
    self.userLabel.text = "\(self.model?.name ?? "") sent you a friend request."
    self.emailLabel.text = " \(self.model?.email ?? "")"
    
    if model.status == "Confirmed" {
      self.confirmBtn.setTitle("Accepted", for: .normal)
      self.confirmBtn.setTitleColor( UIColor.appColor(.tabBarSelected), for: .normal)
      self.confirmBtn.backgroundColor = .clear
      self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
      self.confirmBtn.layer.borderWidth = 1
      self.confirmBtn.layer.borderColor = UIColor.appColor(.tabBarSelected)?.cgColor
      
      
      self.declineBtn.backgroundColor = .clear
      self.declineBtn.layer.borderWidth = 1
      self.declineBtn.layer.borderColor = UIColor.clear.cgColor
      self.declineBtn.setTitle("", for: .normal)
      self.declineBtn.setTitleColor( UIColor.clear, for: .normal)


      
    }
    else if model.status == "Created" {
      self.declineBtn.isHidden = false
      self.confirmBtn.isHidden = false

      
      self.confirmBtn.setTitle("Accept", for: .normal)
      self.confirmBtn.setTitleColor( .white, for: .normal)
      self.confirmBtn.backgroundColor = UIColor.appColor(.highlight)
      self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
      self.confirmBtn.layer.borderWidth = 1
      self.confirmBtn.layer.borderColor = UIColor.appColor(.highlight)?.cgColor
      
      self.declineBtn.setTitle("Reject", for: .normal)
          self.declineBtn.setTitleColor( .white, for: .normal)
          self.declineBtn.backgroundColor = UIColor.appColor(.highlight)
          self.declineBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
          self.declineBtn.layer.borderWidth = 1
          self.declineBtn.layer.borderColor = UIColor.appColor(.highlight)?.cgColor

    
    }
    else if model.status == "Declined"{
      self.declineBtn.setTitle("Rejected", for: .normal)
      self.declineBtn.setTitleColor( UIColor.appColor(.tabBarSelected), for: .normal)
      self.declineBtn.backgroundColor = .clear
      self.declineBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
      self.declineBtn.layer.borderWidth = 1
      self.declineBtn.layer.borderColor = UIColor.appColor(.tabBarSelected)?.cgColor
      self.confirmBtn.backgroundColor = .clear
      self.confirmBtn.layer.borderWidth = 1
      self.confirmBtn.layer.borderColor = UIColor.clear.cgColor
      self.declineBtn.setTitle("", for: .normal)
      self.declineBtn.setTitleColor( UIColor.clear, for: .normal)
    }
    self.userImage.maskCircle()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func confirmPressed(_ sender: Any) {
    if let model = self.model {
      
      friendHandler.confirmFriendRequest(model) {
        NotificationCenter.default.post(name: .updateFriendRequests, object: nil)
        NotificationCenter.default.post(name: .checkRequest, object: nil)
        
      }
      
      
    }
  }
  
  @IBAction func declinePressed(_ sender: Any) {
    
    if let model = self.model {
      friendHandler.declineFriendRequest(model) {
        NotificationCenter.default.post(name: .updateFriendRequests, object: nil)
        NotificationCenter.default.post(name: .checkRequest, object: nil)
        
        
      }
    }
  }
}
