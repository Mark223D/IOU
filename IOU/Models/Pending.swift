//
//  Pending.swift
//  IOU
//
//  Created by Mark Debbane on 11/26/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Pending {
    var ref: DatabaseReference?

    var id: String?
    var title: String?
    var description: String?
    var amount: Int? // Amount Paid
    var created: String? // Date of confirmation
    var giver: String? //Person that gave money to the other user
    var status: String? // Confirmed - Pending
    
    typealias JSON = [String: Any]

    
    init (snapshot: DataSnapshot) {
           ref = snapshot.ref

            let data = snapshot.value as! Dictionary<String, Any>
                self.id = data["id"] as? String
                  self.title = data["title"] as? String
                  self.description = data["description"] as? String
                  self.amount = data["amount"] as? Int
                  self.created = data["created"] as? String
                  self.giver = data["giver"] as? String
                  self.status = data["status"] as? String
       }

}


