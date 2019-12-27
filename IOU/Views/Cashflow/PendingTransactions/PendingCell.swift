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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
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
                        let amount = model.amount,
                        let created = model.created,
                        let title = model.title,
                        let description = model.description
                    {
                        
                        if user.uid == model.giver {
                            self.userLabel.text = "You gave \(firstName)"
                            
                        }else{
                            self.userLabel.text = "\(firstName) gave you"
                            
                        }
                        
                        //User is not sender: Need to confirm transaction
                        if (user.uid != model.sender) && (model.status != "Confirmed")
                            {
                                self.confirmBtn.setTitle("CONFIRM", for: .normal)
                                self.confirmBtn.setTitleColor(.green, for: .normal)
                                self.confirmBtn.isEnabled = true
                            
                        }
                        //User is sender: No need to confirm anything
                        else if (user.uid == model.sender) && (model.status != "Confirmed") {
                                self.confirmBtn.setTitle("SENT", for: .normal)
                                self.confirmBtn.setTitleColor(.lightGrey, for: .normal)
                                self.confirmBtn.isEnabled = false
                            
                        }
                        //Transaction has been confirmed
                        else {
                                self.confirmBtn.setTitle("CONFIRMED", for: .normal)
                                self.confirmBtn.setTitleColor(.lightGrey, for: .normal)
                                self.confirmBtn.isEnabled = false
                                
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
                        
                        
                        self.titleLabel.text = title
                        self.descriptionLabel.text = description
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


