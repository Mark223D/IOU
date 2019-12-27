//
//  IOUUser.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import FirebaseDatabase


class IOUUser {
    var ref: DatabaseReference?
    
    var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    
    
    typealias JSON = [String: Any]
    
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.id = data["id"] as? String
        self.email = data["email"] as? String
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
    }
    
}

class Friend {
    var ref: DatabaseReference?
    
    var id: String?
    var firstName: String?
    var sender: String?
    var receiver: String?
    var created: String?
    var status: String?
    
    typealias JSON = [String: Any]
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.id = snapshot.key
        self.firstName = data["name"] as? String
        self.sender = data["sender"] as? String
        self.receiver = data["receiver"] as? String
        self.status = data["status"] as? String
        self.created = data["created"] as? String
        
    }
    
}
