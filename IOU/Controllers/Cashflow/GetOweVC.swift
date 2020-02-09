//
//  GetOweVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/6/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class GetOweVC: MainVC {
    var user: User!
    var ref: DatabaseReference!
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var fromToLabel: UILabel!
    @IBOutlet weak private var getOweLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    
    var isGet: Bool?
    var items: [CashFlow] = []
    var getTotal: Int = 0
    var oweTotal: Int = 0
    
    let formatter: CurrencyFormatter = CurrencyFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
        self.ref = Database.database().reference()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserCashflow" {
            let vc = segue.destination as! UserCashFlowVC
            vc.userID = sender as? String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let get = isGet {
            if get{
                self.getOweLabel.text = "You Get"
                self.fromToLabel.text = "From"
                self.amountLabel.text = self.formatter.formatAmountToLBP(self.getTotal)
            }
            else{
                self.getOweLabel.text = "You Owe"
                self.fromToLabel.text = "To"
                self.amountLabel.text = self.formatter.formatAmountToLBP(self.oweTotal)
            }
            
        }
    }
}



extension GetOweVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toUserCashflow", sender: self.items[indexPath.row].userID)
        
    }
}

extension GetOweVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:IOUTransCell = tableView.dequeueReusableCell(withIdentifier: "IOUTransCell") as! IOUTransCell
        
        if let get = self.isGet {
            cell.setModel(items[indexPath.row], get)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height/8
        
    }
    
}


extension GetOweVC {
    func initUI(){
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "IOUTransCell", bundle: nil), forCellReuseIdentifier: "IOUTransCell")
    }
}