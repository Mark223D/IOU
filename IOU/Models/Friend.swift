//
//  Friend.swift
//  IOU
//
//  Created by Mark Debbane on 2/19/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import Foundation
import Firebase

class Friend {
    var ref: DatabaseReference?
    
    var id: String?
    var name: String?
    var email: String?
    var sender: String?
    var receiver: String?
    var created: String?
    var status: String?
    
    typealias JSON = [String: Any]
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.id = snapshot.key
        self.name = data["name"] as? String
        self.email = data["email"] as? String
        self.sender = data["sender"] as? String
        self.receiver = data["receiver"] as? String
        self.status = data["status"] as? String
        self.created = data["created"] as? String
        
    }
    
}

extension Friend: Hashable{
  
  static func == (lhs: Friend, rhs: Friend) -> Bool {
    return lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
}
