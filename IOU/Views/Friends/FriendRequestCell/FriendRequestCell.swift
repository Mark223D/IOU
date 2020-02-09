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
        
        self.declineBtn.layer.cornerRadius = 10
        self.confirmBtn.layer.cornerRadius = 10
        self.userImage.maskCircle()
        
        
    }
    
    func setModel(_ model: Friend){
        self.model = model
        self.userLabel.text = self.model?.name ?? ""
        self.emailLabel.text = self.model?.email ?? ""

        
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
