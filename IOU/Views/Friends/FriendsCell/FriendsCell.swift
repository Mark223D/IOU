//
//  FriendsCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/6/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var userModel: IOUUser?
     var friendModel: Friend?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height/2
      self.avatarImageView.setIcon(icon: .fontAwesomeSolid(.user), textColor: .white, backgroundColor: UIColor.appColor(.highlight) ?? .orange)
//      self.avatarImageView.backgroundColor = UIColor.appColor(.highlight)
      self.backgroundColor = UIColor.appColor(.background)
      self.nameLabel.textColor = UIColor.appColor(.tabBarSelected)
      self.emailLabel.textColor = UIColor.appColor(.tabBarSelected)

    }
    
    
    func setModelUser(_ model: IOUUser){
        
        self.userModel = model
        
        self.nameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "" )"
        
    }
    
    
    func setModelFriend(_ model: Friend){
        
        self.friendModel = model
        
        self.nameLabel.text = model.name
        self.emailLabel.text = model.email

    }
    
}
