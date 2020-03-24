//
//  PendingCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/26/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class PendingCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: Transaction?
    var friend: Friend?
    let cashflowHandler = CashFlowHandler()
    let formatter = CurrencyFormatter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
    }
    func setModel(_ model: Transaction,  _ friend: Friend)
    {
        self.model = model
        self.friend = friend
        
        if let friendID = friend.id {
            cashflowHandler.getUser(friendID) { (otherUser) in
                self.cashflowHandler.getSignedInUser { (user) in
                    
                    if let firstName = otherUser.firstName,
                      let lastName = otherUser.lastName,
                        let amount = model.amount,
                        let created = model.created
                    {
                        
                        if user.uid == model.giver {
                            self.userLabel.text = "You gave \(firstName) \(lastName)"
                            
                        }else{
                            self.userLabel.text = "\(firstName) \(lastName) gave you"
                            
                        }
                        
                        //User is not sender: Need to confirm transaction
                        if (user.uid != model.sender) && (model.status != "Confirmed")
                            {
                                self.confirmBtn.setTitle("Confirm", for: .normal)
                                self.confirmBtn.setTitleColor(UIColor.appColor(.highlight), for: .normal)
                                self.confirmBtn.isEnabled = true
                              self.confirmBtn.backgroundColor = .clear
                                                      self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
                                                      self.confirmBtn.layer.borderWidth = 1
                              self.confirmBtn.layer.borderColor = UIColor.appColor(.highlight)?.cgColor
                            
                        }
                        //User is sender: No need to confirm anything
                        else if (user.uid == model.sender) && (model.status != "Confirmed") {
                                self.confirmBtn.setTitle("Sent", for: .normal)
                                self.confirmBtn.setTitleColor(UIColor.appColor(.tabBarSelected), for: .normal)
                                self.confirmBtn.isEnabled = false
                          
                          self.confirmBtn.backgroundColor = .clear
                          self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
                          self.confirmBtn.layer.borderWidth = 1
                          self.confirmBtn.layer.borderColor = UIColor.appColor(.tabBarSelected)?.cgColor
                            
                        }
                        //Transaction has been confirmed
                        else {
                                self.confirmBtn.setTitle("Confirmed", for: .normal)
                          self.confirmBtn.setTitleColor(UIColor.appColor(.tabBarSelected), for: .normal)
                                self.confirmBtn.isEnabled = false
                          self.confirmBtn.backgroundColor = .clear
                          self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height/2
                          self.confirmBtn.layer.borderWidth = 1
                          self.confirmBtn.layer.borderColor = UIColor.appColor(.tabBarSelected)?.cgColor
                          self.confirmBtn.titleEdgeInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
                                
                            }
                        self.userImage.maskCircle()
                        self.amountLabel.text = self.formatter.formatAmountToLBP(amount)
                        
                        
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.timeZone = .current
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.timeZone = .autoupdatingCurrent
                        //                        dateFormatterPrint.
                        dateFormatterPrint.dateFormat = "E, dd MMM yyyy @ h:mm a"
                        
                        if let date = dateFormatterGet.date(from: created) {
                            
                            self.dateLabel.text = dateFormatterPrint.string(from: date)
                            
                        } else {
                            print("There was an error decoding the string")
                        }
                        
                  }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func confirmPressed(_ sender: Any) {
        confirmBtn.isEnabled = false
        confirmRequest()
    }
    
    func confirmRequest(){
        
        
        if let friend = self.friend, let model = self.model {
            cashflowHandler.respondTransaction(friend, transaction: model) {
                
                NotificationCenter.default.post(name: .updatePending, object: nil)
                NotificationCenter.default.post(name: .checkPending, object: nil)
                
            }
        }
    }
}


