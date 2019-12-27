//
//  FriendHandler.swift
//  IOU
//
//  Created by Mark Debbane on 11/30/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import Firebase

class FriendHandler: NetworkHandler {
    
    func searchUser(_ text: String, completion: @escaping (([IOUUser]) -> Void)){
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                ref.child("users")
                    .queryOrdered(byChild: "firstName")
                    .queryStarting(atValue: text)
                    .observeSingleEvent(of: .value)
                    { snapshot in
                        
                        var friends: [IOUUser] = []
                        
                        for item in snapshot.children {
                            
                            guard let item = item as? DataSnapshot else { return  }
                            
                            let tempUser = IOUUser(snapshot: item)
                            
                            if tempUser.id != user.uid {
                                
                                ref.child("friends")
                                    .child(user.uid)
                                    .observeSingleEvent(of: .value)
                                    { snapshot in
                                        
                                        if let tempUserID = tempUser.id, let userIsContained = (tempUser.firstName?.contains(text))
                                        {
                                            if !(snapshot.hasChild(tempUserID)) && (userIsContained)
                                            {
                                                friends.append(tempUser)
                                            }
                                        }
                                        else{
                                            print("SearchUser: TempUserID is nil")
                                        }
                                        completion(friends)
                                        
                                        
                                }
                            }
                        }
                }
            }
        }
    }
    
    func getFriends(completion: @escaping (([Friend]) -> Void)){
        setupFirebaseCall { (user) in
            
            var friends: [Friend] = []
            
            if let ref = self.ref {
                
                ref.child("friends")
                    .child(user.uid)
                    .observe(.value)
                    { (snapshot) -> Void in
                        
                        if snapshot.hasChildren(){
                            
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                
                                for snap in snapshots
                                {
                                    let friend = Friend(snapshot: snap)
                                    
                                    if friend.status == "Confirmed" && friend.id != user.uid{
                                        friends.append(friend)
                                    }
                                }
                                completion(friends)
                            }
                        }
                }
            }
        }
        
    }
    
    func getFriendRequests(completion: @escaping ([Friend]) -> Void){
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                
                ref.child("friends")
                    .child(user.uid)
                    .observe(.value)
                    { (snapshot) in
                        
                        var requests: [Friend] = []
                        let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                        
                        for snap in snapshots {
                            
                            let friend = Friend(snapshot: snap)
                            
                            if friend.status != "Confirmed" && friend.sender != user.uid {
                                requests.append(friend)
                            }
                        }
                        completion(requests)
                }
            }
        }
    }
    
    func sendFriendRequest(_ selectedUser: IOUUser, completion: @escaping ((Bool) -> Void)){
        setupFirebaseCall { (user) in
            if let ref = self.ref{
                
                if let id = selectedUser.id,
                    let selectedFirstName = selectedUser.firstName,
                    let selectedLastName = selectedUser.lastName {
                    
                    let selectedUserName = "\(selectedFirstName) \(selectedLastName)"
                    
                    ref.child("users")
                        .child(user.uid)
                        .observeSingleEvent(of: .value)
                        { (snapshot) in
                            
                            let signedInUser = IOUUser(snapshot: snapshot)
                            
                            if let userFirstName = signedInUser.firstName,
                                let userLastName = signedInUser.lastName
                            {
                                
                                let userName = "\(userFirstName) \(userLastName)"
                                ref.child("friends")
                                    .child(user.uid)
                                    .child(id)
                                    .setValue(
                                        [
                                            "name": selectedUserName,
                                            "sender": user.uid,
                                            "status": "Sent",
                                            "created": Date().description
                                    ])
                                
                                ref.child("friends")
                                    .child(id)
                                    .child(user.uid).setValue(
                                        [
                                            "name": userName,
                                            "sender": user.uid,
                                            "status": "Sent",
                                            "created": Date().description
                                    ])
                                completion(true)
                            }
                            else{
                                print("SendFriendRequest: Signedin User FirstName is nil")
                                completion(false)
                            }
                            
                    }
                }
                else{
                    print("SendFriendRequest: Selected UserID or FirstName is nil")
                    completion(false)
                    
                }
            }
        }
        
    }
    
    func confirmFriendRequest(_ model: Friend, completion: @escaping (() -> Void )){
        setupFirebaseCall { (user) in
            
            if let ref = self.ref {
                ref.child("users")
                    .child(user.uid)
                    .observeSingleEvent(of: .value)
                    { (snapshot) in
                        let signedInUser = IOUUser(snapshot: snapshot)
                        
                        
                        if let sender = model.sender,
                            let userFirstName = signedInUser.firstName,
                            let userLastName = signedInUser.lastName
                            
                        {
                            
                            self.getUser(sender) { (senderUser) in
                                
                                if let senderFirstName = senderUser.firstName,
                                    let senderLastName = senderUser.lastName
                                {
                                    ref.child("friends")
                                        .child(user.uid)
                                        .child(sender)
                                        .updateChildValues([
                                            "status" : "Confirmed"])
                                    
                                    ref.child("friends")
                                        .child(sender)
                                        .child(user.uid)
                                        .updateChildValues([
                                            "status" : "Confirmed"])
                                    
                                    ref.child("cashflows")
                                        .child(user.uid)
                                        .child(sender)
                                        .setValue(
                                            ["amount" : 0,
                                             "userID": sender,
                                             "name": "\(senderFirstName) \(senderLastName)"])
                                    
                                    ref.child("cashflows")
                                        .child(sender)
                                        .child(user.uid)
                                        .setValue([
                                            "amount" : 0,
                                            "userID": sender,
                                            "name": "\(userFirstName) \(userLastName)"])
                                }
                                
                            }
                        }
                }
            }
            
        }
    }
    
    func declineFriendRequest(_ model: Friend, completion: @escaping (() -> Void)){
        
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                if let sender = model.sender{
                    ref.child("friends").child(user.uid).child(sender).updateChildValues(["status" : "Declined"])
                    ref.child("friends").child(sender).child(user.uid).updateChildValues(["status" : "Declined"])
                }
            }
        }
        
        
    }
}
