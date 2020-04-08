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
    @IBOutlet weak var amountView: HomeCard!
  
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
        self.amountView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMaxYCorner, ], radius: 40, borderColor: UIColor.appColor(.tabBarSelected) ?? .green, borderWidth: 3)
    }
    
    /*
     MARK: - Setup UserCashflow
     */
    func setupCashflow(){
        self.items.removeAll()
    

        let userCashflow = CashFlowHandler()
        if let user = self.userID {
            userCashflow.getUserTransactions(user) { (transactions) in
              self.items = transactions
              self.total = 0

              for transaction in transactions {
                if let amount = transaction.amount {
                  if  transaction.giver == user  {//Signed In user is giver
                    self.total += amount //So add to total of user cashflow
                    
                  }
                  else {//Signed in user is taker
                    
                    self.total  -= amount // So remove from total of user cashflow
                    
                  }
                }
              }
              
              if self.total < 0{
                self.amountLabel.text = self.formatter.formatAmountToLBP(self.total * -1)
              }
              else{
                self.amountLabel.text = self.formatter.formatAmountToLBP(self.total)

              }

                
                self.tableView.reloadData()
            }
            
            userCashflow.getUser(user) { (user) in
                if let name = user.firstName {
                  if self.total < 0{
                    self.title = "From \(name)"

                  }
                  else if self.total > 0 {
                    self.title = "\(name)"

                  }
                    self.userName = name
                }
                else{
                    self.title = "Error"
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
