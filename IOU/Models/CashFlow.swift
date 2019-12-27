//
//  CashFlow.swift
//  IOU
//
//  Created by Mark Debbane on 11/21/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CashFlow {
    
    var ref: DatabaseReference?
    var userID: String?
    var username: String?
    var amount: Int?

    typealias JSON = [String: Any]
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.userID = snapshot.key
        self.username = data["name"] as? String
        self.amount = data["amount"] as? Int
    }
}
