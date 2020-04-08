//
//  ActivityVC.swift
//  IOU
//
//  Created by Mark Debbane on 3/24/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit
import Firebase

class ActivityModel {
  private var sent : [Transaction] = []
  private var received: [Transaction] = []
  var friends: [Friend] = []
  var friendRequests: [Friend] = []
  var items: [ActivityCellModel]?
  var noDup: Set<ActivityCellModel>?
  init() {
    items = []
    noDup = Set<ActivityCellModel>()
  }
  func fetchData(completion: @escaping () -> ()){
    
    self.getPending {
      self.getData {
        self.getFriends {
          self.getItems()

          completion()
          
        }
      }
    }
  }
  
  func getFriends(completion: @escaping () -> ())
  {
    let friendHandler = FriendHandler()
    friendHandler.getFriends { (friends) in
      self.friends = friends
      print(friends)
      completion()
    }
  }
  
  func getData(completion: @escaping () -> ()){
    let cashflowHandler = CashFlowHandler()
    cashflowHandler.getAllTransactions { (received, sent) in
      self.sent.removeAll()
      self.sent.removeAll()
      self.sent = sent
      self.received = received
      
      completion()
    }
  }
  func getItems(){
     let _ = self.sent.map { (transaction) -> () in
      let model = ActivityCellModel(transaction: transaction)
      self.noDup?.insert(model)
    }
    let _ = self.received.map { (transaction) -> () in
      let model = ActivityCellModel(transaction: transaction)
      self.noDup?.insert(model)
    }
     let _ = self.friends.map { (friend) -> () in
      let model = ActivityCellModel(friend: friend)
      self.noDup?.insert(model)
    }
    
    let order = ComparisonResult.orderedDescending
    self.items = self.noDup?.sorted(by: { (elem1, elem2) -> Bool in
      if elem1.getType() == .friend{
        if elem2.getType() == .friend{ // Friend  & Friend
          return decodeDate(str: elem1.getFriend()?.created ?? "").compare(decodeDate(str: elem2.getFriend()?.created ?? "")) == order
        }
        else { //Friend  & Transaction
          return decodeDate(str: elem1.getFriend()?.created ?? "").compare(decodeDate(str: elem2.getTransaction()?.created ?? "" )) == order

        }
      }
      else {
        if elem2.getType() == .transaction{ // Transaction  & Transaction
          return decodeDate(str: elem1.getTransaction()?.created ?? "").compare(decodeDate(str: elem2.getTransaction()?.created ?? "")) == order

        }
        else { // Transaction & Friend
          return decodeDate(str: elem1.getTransaction()?.created ?? "").compare(decodeDate(str: elem2.getFriend()?.created ?? "")) == order
        }
      }
    })
  }
  
  func decodeDate(str: String) -> Date {
    let dateFormatterGet = DateFormatter()
                          dateFormatterGet.timeZone = .current
                          dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                          
                          let dateFormatterPrint = DateFormatter()
                          dateFormatterPrint.timeZone = .autoupdatingCurrent
                          dateFormatterPrint.dateFormat = "E, dd MMM yyyy @ h:mm a"
                          
                          if let date = dateFormatterGet.date(from: str) {
                              
                              return date
                              
                          } else {
                              print("There was an error decoding the string")
                          }
    return Date()
  }
  
  
  
  func getPending(completion: @escaping () -> ()){
    
    let friendHandler = FriendHandler()
    friendHandler.getFriendRequests { (requests) in
      self.friendRequests = requests
      completion()
    }
  }
}

class ActivityVC: UIViewController {
  
  private let screenSize: CGRect = UIScreen.main.bounds
  private var lastContentOffset: CGFloat = 0
  
  @IBOutlet weak var tableView: UITableView!
  
  var model: ActivityModel = ActivityModel()
  
  private var selectedContent:Transaction?
  private var ref:DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "FriendRequestCell")
    self.tableView.register(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: "PendingCell")
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateFriendReq(_:)), name: .updateFriendRequests, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.callGetData(_:)), name: .updatePending, object: nil)
    self.tabBarItem.image = UIImage(named: "activity")

        if traitCollection.userInterfaceStyle == .light {
                     print("Light mode")
                self.tabBarItem.selectedImage = UIImage(named: "activity-active-blue")
                 } else {
                     print("Dark mode")
                self.tabBarItem.selectedImage = UIImage(named: "activity-active-white")

                 }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    self.model.fetchData {
      self.tableView.reloadData()
      
    }
    
    
  }
  
  
}

//Transaction Area
extension ActivityVC {
  @objc func callGetData(_ notification: Notification){
    self.model.fetchData {
      self.tableView.reloadData()
    }
    
  }
  
}
//Friends Area
extension ActivityVC{
  
  @objc func updateFriendReq(_ notification: Notification){
    self.tableView.reloadData()
  }
  
}

extension ActivityVC: UITableViewDelegate {
  
}


extension ActivityVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.model.items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if self.model.items?[indexPath.row].getType() == .friend {
      //For friends
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as! FriendRequestCell
      
      if let model = self.model.items?[indexPath.row].getFriend() {
        cell.setModel(model)
        
      }
      
      
      return cell
    }
    else {
      //FOR Transaction Cells
      let cell = tableView.dequeueReusableCell(withIdentifier: "PendingCell") as! PendingCell
      if let model = self.model.items?[indexPath.row].getTransaction() {
        
        let list = self.model.friends.filter({ (friend) -> Bool in
          (friend.id == model.receiver!) || (friend.id == model.giver!)
        })
        if let first = list.first {
          cell.setModel(model, first)
          return cell
          
        }
        
      }
      
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if self.model.items?[indexPath.row].getType() == .friend {
      return self.tableView.frame.height * 0.15 // For Friends
      
    }
    else{
      return tableView.frame.height/6.5 // For Transactions
      
    }
    
  }
}

