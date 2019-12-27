//
//  NetworkHandler.swift
//  IOU
//
//  Created by Mark Debbane on 11/30/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import Firebase

class NetworkHandler {
    
    var currentUser: User?
    var ref: DatabaseReference?
    
    init() {
        guard let user = Auth.auth().currentUser else { return }
        self.ref = Database.database().reference()
        self.currentUser = user
    }
    
    func setupFirebaseCall(completion: @escaping (User) -> Void)
    {
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else { return  }
            
            completion(user)
            
        }
    }
    
    func getSignedInUser(completion: @escaping (User) -> Void) {
        setupFirebaseCall { (user) in
            completion(user)
        }
    }
    
    func getUser(_ userID: String, completion: @escaping ((IOUUser) -> Void)){
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                ref.child("users")
                    .child(userID)
                    .observe(.value)
                    { (snapshot) -> Void in
                        let user = IOUUser(snapshot: snapshot)
                        
                        completion(user)
                }
            }
        }
    }
    
    deinit {
        self.ref = nil
        self.currentUser = nil
    }
    
}
