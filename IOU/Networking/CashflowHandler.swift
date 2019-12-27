//
//  CashflowHandler.swift
//  IOU
//
//  Created by Mark Debbane on 11/30/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import Firebase

class CashFlowHandler: NetworkHandler {
    
    func getUserCashflow(completion: @escaping( ((Int, [CashFlow]), (Int, [CashFlow])) -> Void )){
        
        var getItems: [CashFlow] = []
        var oweItems: [CashFlow] = []
        var getTotal: Int = 0
        var oweTotal: Int = 0
        
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                ref.child("cashflows")
                    .child(user.uid)
                    .observe(.childAdded)
                    { (snapshot) -> Void in
                        
//                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                            for snap in snapshots
//                            {
                                let cashflow = CashFlow(snapshot: snapshot)
                                guard let amount = cashflow.amount else { return  }
                                
                                if amount > 0
                                {
                                    getItems.append(cashflow)
                                    getTotal += amount
                                }
                                else if amount < 0
                                {
                                    oweItems.append(cashflow)
                                    oweTotal += amount
                                }
                                
//                            }
                            completion((getTotal, getItems), (oweTotal, oweItems))
//                        }
                }
            }
        }
    }
    
    func getUserTransactions(_ userID: String, completion: @escaping ((Int, [Transaction]) -> Void)){
        var userTransactions: [Transaction] = []
        var userTotal: Int = 0
        
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                ref.child("transactions")
                    .child(user.uid)
                    .child(userID)
                    .observe(.childAdded)
                    { (snapshot) -> Void in

                                let transaction = Transaction(snapshot: snapshot)
                                
                                if let confirmed = transaction.status {
                                    if confirmed == "Confirmed"{
                                        userTransactions.append(transaction)
                                        userTransactions = userTransactions.sorted { (t1, t2) -> Bool in
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.timeZone = .current
                                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                            
                                            
                                            if let c1 = t1.created, let c2 = t2.created{
                                                if let d1 = dateFormatter.date(from: c1), let d2 = dateFormatter.date(from: c2){
                                                    return d1.compare(d2) == .orderedDescending
                                                }
                                            }
                                            return false
                                        }
                                        
                                        if let amount = transaction.amount {
                                            if  transaction.giver == user.uid  {//Signed In user is giver
                                                
                                                userTotal += amount //So you add from total of user cashflow
                                                
                                            }
                                            else {//Signed in user is taker
                                                userTotal += amount * -1 // So you remove to total of user cashflow
                                                
                                            }
                                        }
                                        
                                    }
                            completion(userTotal, userTransactions)
                        }
                }
            }
        }
    }
    
    func respondTransaction(_ friend: Friend, transaction: Transaction, completion: @escaping (()->Void) ){
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                if let friendID = friend.id, let created = transaction.created {
                    ref.child("transactions")
                        .child(user.uid)
                        .child(friendID)
                        .child(created)
                        .updateChildValues(["status": "Confirmed"])
                    ref.child("transactions")
                        .child(friendID)
                        .child(user.uid)
                        .child(created)
                        .updateChildValues(["status": "Confirmed"])
                    
                    self.updateCashFlows(friend, transaction)
                    
                    completion()
                }
                
            }
        }
    }
    
    func updateCashFlows(_ friend: Friend,_ transaction: Transaction){
        setupFirebaseCall { (user) in
            if let ref = self.ref,
                let friendID = friend.id,
                let amount = transaction.amount,
                let giver = transaction.giver {
                
                ref.child("cashflows")
                    .child(user.uid)
                    .child(friendID)
                    .observeSingleEvent(of: .value) { (snapshot) in
                        
                        let cashflow = CashFlow(snapshot: snapshot)
                        if let cashflowAmount = cashflow.amount{
                            
                            
                            ref.child("cashflows")
                                .child(user.uid)
                                .child(friendID)
                                .updateChildValues(
                                    ["amount": user.uid == giver ? (cashflowAmount + amount) : (cashflowAmount - amount)])
                            
                        }
                        
                }
                
                
                
                ref.child("cashflows")
                    .child(friendID)
                    .child(user.uid)
                    .observeSingleEvent(of: .value) { (snapshot) in
                        
                        let cashflow = CashFlow(snapshot: snapshot)
                        if let cashflowAmount = cashflow.amount{
                            
                            
                            ref.child("cashflows")
                                .child(friendID)
                                .child(user.uid)
                                .updateChildValues(["amount": friendID == giver ? (cashflowAmount + amount) : (cashflowAmount - amount)])
                            
                        }
                        
                }
            }
        }
        
    }
    
    
    func getAllTransactions(completion: @escaping (([Transaction], [Transaction])->Void)){
        var sent: [Transaction] = []
        var received: [Transaction] = []
        setupFirebaseCall { (user) in
            if let ref = self.ref {
                ref.child("transactions")
                    .child(user.uid)
                    .observe(.childAdded)
                    { (snapshot) in
                        
                        let Fsnapshots = snapshot.children.allObjects as! [DataSnapshot]
                        
                        for Fsnap in Fsnapshots {
                                let pending = Transaction(snapshot: Fsnap)
                                
                                if pending.sender == user.uid {
                                    
                                    sent.append(pending)
                                    
                                }
                                else{
                                    
                                    received.append(pending)
                                    
                                }
                                
                                received = received.sorted { (t1, t2) -> Bool in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.timeZone = .current
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                    
                                    
                                    if let c1 = t1.created, let c2 = t2.created{
                                        if let d1 = dateFormatter.date(from: c1), let d2 = dateFormatter.date(from: c2){
                                            return d1.compare(d2) == .orderedDescending
                                        }
                                    }
                                    return false
                                }
                                sent = sent.sorted { (t1, t2) -> Bool in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.timeZone = .current
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                    
                                    
                                    if let c1 = t1.created, let c2 = t2.created{
                                        if let d1 = dateFormatter.date(from: c1), let d2 = dateFormatter.date(from: c2){
                                            return d1.compare(d2) == .orderedDescending
                                        }
                                    }
                                    return false
                                }
                        }
                        completion(received, sent)
                }
            }
        }
    }
    
    func formatTransaction(amount: String,
                           title: String,
                           description: String,
                           give: Bool,
                           selectedUsers: [Friend],
                           each: Bool,
                           completion: @escaping ((Bool) -> Void)){
        
        setupFirebaseCall { (user) in
            
            guard let newAmount = Int(amount.replacingOccurrences(of: ",", with: "")) else {
                print("Amount Conversion to Int failed before sending transaction")
                return
            }
            
            let date = Date().description
            
            for selected in selectedUsers {
                if let selectedID = selected.id {
                    if give {
                        
                        self.sendTransaction(amount: each ? newAmount : newAmount/selectedUsers.count ,
                                             title: title,
                                             description: description,
                                             date: date,
                                             giver: user.uid,
                                             receiver: selectedID)
                    }
                        
                    else{
                        
                        self.sendTransaction(amount: each ? newAmount : newAmount/selectedUsers.count,
                                             title: title,
                                             description: description,
                                             date: date,
                                             giver: selectedID,
                                             receiver: user.uid)
                    }
                    completion(true)
                }
                completion(false)
            }
        }
    }
    
    
    
    func sendTransaction(amount: Int,
                         title: String,
                         description: String,
                         date: String,
                         giver: String,
                         receiver: String){
        
        setupFirebaseCall { (user) in
            
            if let ref = self.ref {
                //Add To Giver
                ref.child("transactions")
                    .child(giver)
                    .child(receiver)
                    .child(date)
                    .setValue(
                        [
                            "title": title,
                            "description": description,
                            "amount": amount,
                            "created": date,
                            "giver": giver,
                            "sender": user.uid,
                            "receiver": receiver,
                            "status" : "Created"])
                
                //AddTo Receiver
                ref.child("transactions")
                    .child(receiver)
                    .child(giver)
                    .child(date)
                    .setValue(
                        [
                            "title": title,
                            "description": description,
                            "amount": amount,
                            "created": date,
                            "giver": giver,
                            "sender": user.uid,
                            "receiver": receiver,
                            "status" : "Created"])
            }
        }
        
    }
    
}

