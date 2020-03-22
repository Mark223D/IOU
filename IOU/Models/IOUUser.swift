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
    var pushToken: String?
  
    typealias JSON = [String: Any]
    
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, Any>
        self.id = data["id"] as? String
        self.email = data["email"] as? String
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.pushToken = data["pushToken"] as? String
    }
    
}
