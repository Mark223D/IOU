//
//  FriendRequestsVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/26/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestsVC: MainVC {
    
    var items: [Friend] = []
    var ref: DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        self.iniUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFriendReq(_:)), name: .updateFriendRequests, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPending()
        
    }
    
    func getPending(){
        
        let friendHandler = FriendHandler()
        friendHandler.getFriendRequests { (requests) in
            self.items = requests
            self.tableView.reloadData()
        }
    }
    
    @objc func updateFriendReq(_ notification: Notification){
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension FriendRequestsVC: UITableViewDelegate{
    
}

extension FriendRequestsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as! FriendRequestCell
        
        cell.setModel(self.items[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height * 0.15
        
    }
}


extension FriendRequestsVC {
    
    func iniUI(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "FriendRequestCell")
        
    }
}
