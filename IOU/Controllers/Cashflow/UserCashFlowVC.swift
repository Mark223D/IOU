//
//  UserCashFlowVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class UserCashFlowVC: MainVC {
    var userID: String?
    var ref: DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var items:[Transaction] = []
    var userName: String?
    var total: Int = 0
    let formatter = CurrencyFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        self.initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserTotal(_:)), name: .updateUserCashflowTotal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCashflow()
    }
    
    /*
     MARK: - Setup UserCashflow
     */
    func setupCashflow(){
        self.items.removeAll()
        self.total = 0
    

        let userCashflow = CashFlowHandler()
        if let user = self.userID {
            userCashflow.getUserTransactions(user) { (total, transactions) in
                self.total = total
                self.items = transactions
                self.amountLabel.text = self.formatter.formatAmountToLBP(self.total)
                
                self.tableView.reloadData()
            }
            
            userCashflow.getUser(user) { (user) in
                if let name = user.firstName {
                    self.userLabel.text = "You & \(name)"
                    self.userName = name
                }
                else{
                    self.userLabel.text = "Error"
                }
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailedCashflowVC {
            
            let newVC = segue.destination as? DetailedCashflowVC
            newVC?.items = self.items
            newVC?.userName = self.userName
            
            
        }
        
    }
    
    @objc func updateUserTotal(_ notification: Notification?){
        
        print("Update User Total")
        
    }
    
}


extension UserCashFlowVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetailedUserCashflow", sender: nil)
        
    }
}
extension UserCashFlowVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:IOUTransCell = tableView.dequeueReusableCell(withIdentifier: "IOUTransCell") as! IOUTransCell
        
        let model = self.items[indexPath.row]
        
        let firebase = NetworkHandler()
        firebase.setupFirebaseCall { (user) in
            
            if model.giver == user.uid {
                //Signed In user is giver
                cell.setGiveCell(model)
            }
            else{
                //Signed in user is taker
                cell.setOweCell(model)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height/8
        
    }
    
}


extension UserCashFlowVC {
    
    func initUI(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "IOUTransCell", bundle: nil), forCellReuseIdentifier: "IOUTransCell")

        
    }
    
}