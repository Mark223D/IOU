//
//  Activity.swift
//  IOU
//
//  Created by Mark Debbane on 3/24/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import Foundation

enum ActivityType{
  case friend
  case transaction
}

class ActivityCellModel: Hashable {
  func hash(into hasher: inout Hasher) {
    if self.getType() == .friend {
      hasher.combine(self.getFriend()?.created)
    }
    else{
      hasher.combine(self.getTransaction()?.created)

    }
  }
  
  static func == (lhs: ActivityCellModel, rhs: ActivityCellModel) -> Bool {
    if lhs.type != rhs.type{
      return false
    }
    else if lhs.getType() == .friend {
      if lhs.getFriend()?.created == rhs.getFriend()?.created {
        return true
      }
      else{
        return false
      }
    }
    else {
      if lhs.getTransaction()?.created == rhs.getTransaction()?.created {
        return true
      }
      else{
        return false
      }
    }
  }
  
  private var friend: Friend?
  private var transaction: Transaction?
  
  private var type: ActivityType?
  
  init (){
    
  }
  
  convenience init(transaction: Transaction) {
    self.init()
    self.type = .transaction
    self.transaction = transaction
  }
  
  convenience init(friend: Friend) {
    self.init()
    self.type = .friend
    self.friend = friend
  }
  
  func getFriend() -> Friend? {
    return self.friend
  }
  func getType() -> ActivityType {
    
    return self.type!
  }
  
  func getTransaction() -> Transaction? {
    return self.transaction
  }
  
  
  
}

