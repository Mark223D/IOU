//
//  Transaction.swift
//  IOU
//
//  Created by Mark Debbane on 11/19/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Transaction {
    
    var ref: DatabaseReference?

    var id: String?
    var title: String?
    var description: String?
    var amount: Int? // Amount Paid
    var sender: String?
    var created: String? // Date of confirmation
    var giver: String? //Person that gave money to the other user
    var receiver: String? //Person that received the money from the other user
    var status: String? // Confirmed - Pending
    
    typealias JSON = [String: Any]
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.description = data["description"] as? String
        self.amount = data["amount"] as? Int
        self.sender = data["sender"] as? String
        self.created = data["created"] as? String
        self.receiver = data["receiver"] as? String
        self.giver = data["giver"] as? String
        self.status = data["status"] as? String
        
    }
    
    
}
 
