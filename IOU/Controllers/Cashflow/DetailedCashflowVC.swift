//
//  DetailedCashflowVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class DetailedCashflowVC: MainVC {
    
    var items: [Transaction] = []
    var userName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initU()
        
    }
    
    func initU(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "IOUExpandedTransCell", bundle: nil), forCellReuseIdentifier: "IOUExpandedTransCell")
        if let name = self.userName {
            self.title = "You & \(name)"
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.items.removeAll()
        
    }
    
}

extension DetailedCashflowVC: UITableViewDelegate{
    
}


extension DetailedCashflowVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:IOUExpandedTransCell = tableView.dequeueReusableCell(withIdentifier: "IOUExpandedTransCell") as! IOUExpandedTransCell
        
        if let name = self.userName {
            
            let networkCall = NetworkHandler()
            
            networkCall.setupFirebaseCall { (user) in
                cell.setModel(self.items[indexPath.row], user, name)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height * 0.6
        
    }
    
}

