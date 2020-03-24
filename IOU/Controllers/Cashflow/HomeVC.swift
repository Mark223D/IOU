//
//  HomeVC.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class HomeVC: MainVC, UIGestureRecognizerDelegate {
    @IBOutlet weak var pendingBtn: UIBarButtonItem!
    @IBOutlet weak private var getView: HomeCard!
    @IBOutlet weak private var oweView: HomeCard!
    
    @IBOutlet weak private var getAmount: UILabel!
    @IBOutlet weak private var fromLabel: UILabel!

    @IBOutlet weak private var oweAmount: UILabel!
    @IBOutlet weak private var toLabel: UILabel!
    
    @IBOutlet weak private var addTransactionBtn: UIButton!
    
    var choice: Bool?// false: 0 : Get -- true: 1 : Owe
    
    var getItems: [CashFlow] = []
    var oweItems: [CashFlow] = []
    
    var getTotal: Int = 0
    var oweTotal: Int = 0
    
    let formatter: CurrencyFormatter = CurrencyFormatter()
    
    var received: [Transaction] = []
    var sent: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachTapGestures()
        
        self.tabBarItem.image = #imageLiteral(resourceName: "home")
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_filled")

      self.tabBarController?.tabBar.tintColor = UIColor.appColor(.tabBarSelected)
        addTransactionBtn.layer.cornerRadius = addTransactionBtn.frame.height*0.2
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkPending(_:)), name: .updatePending, object: nil)
      self.view.backgroundColor = UIColor.appColor(.foreground)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GetOweVC {
            
            let newVC = segue.destination as? GetOweVC
            guard let isGet = choice else { return  }
            newVC?.isGet = isGet
            if isGet {
                newVC?.items = getItems
                newVC?.getTotal = getTotal
            }else{
                newVC?.items = oweItems
                newVC?.oweTotal = oweTotal
            }
        }
        else if segue.destination is PendingTransactionsVC {
            
            let newVC = segue.destination as? PendingTransactionsVC
            newVC?.sent = self.sent
            newVC?.received = self.received
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
      self.navigationController?.setStatusBar(backgroundColor: UIColor.appColor(.foreground) ?? .green)
      self.navigationController?.setNavigationBarHidden(false, animated: true)
           self.navigationController?.navigationBar.backgroundColor = UIColor.appColor(.foreground)
      self.navigationController?.navigationBar.tintColor = UIColor.appColor(.tabBarSelected)
                
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
      self.navigationController?.setStatusBar(backgroundColor: UIColor.appColor(.foreground) ?? .green)

           self.navigationController?.navigationBar.backgroundColor = UIColor.appColor(.foreground)
                
        setupCashflow()
        updatePending()
    }
    
    
    
    
    @IBAction func addBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddTrans", sender: self)
        
    }
    
}


extension HomeVC {
    
    func attachTapGestures(){
        let getTapGesture = UITapGestureRecognizer(target: self, action: #selector(getViewPressed(_:)))
        getTapGesture.delegate = self
        getView.addGestureRecognizer(getTapGesture)
        
        let oweTapGesture = UITapGestureRecognizer(target: self, action: #selector(oweViewPressed(_:)))
        oweTapGesture.delegate = self
        oweView.addGestureRecognizer(oweTapGesture)
    }
    
    
    @objc func getViewPressed(_ sender: UIView) {
        self.choice = true
        self.performSegue(withIdentifier: "toGetOwe", sender: self)
        
    }
    
    @objc func oweViewPressed(_ sender: UIView){
        self.choice = false
        self.performSegue(withIdentifier: "toGetOwe", sender: self)
    }
    /*
     MARK: - Setup Cashflow Function
     */
    
    func setupCashflow(){
        
        let cashflowHandler = CashFlowHandler()
        
        cashflowHandler.getUserCashflow { (getTuple, oweTuple) in
            self.getItems.removeAll()
            self.oweItems.removeAll()
            
            let (owe, oItems) = oweTuple
            let (get, gItems) = getTuple
            
            self.oweItems = oItems
            self.getItems = gItems
            
            self.getTotal = get
            self.oweTotal = owe * -1
            
            self.getAmount.text = self.formatter.formatAmountToLBP(self.getTotal)
            self.oweAmount.text = self.formatter.formatAmountToLBP(self.oweTotal)
            
            if let fromNumber = self.format(self.getItems.count), let toNumber = self.format(self.oweItems.count){
                if self.getItems.count > 0 {
                    if self.getItems.count == 1{
                        self.fromLabel.text = "From \(fromNumber) Person"
                    }
                    else {
                        self.fromLabel.text = "From \(fromNumber) People"
                    }
                }
                else{
                    self.fromLabel.text = ""

                }
                
                if self.oweItems.count > 0 {
                           if self.oweItems.count == 1{
                               self.toLabel.text = "To \(toNumber) Person"
                           }
                           else {
                               self.toLabel.text = "To \(toNumber) People"
                           }
                       }
                else{
                    self.toLabel.text = ""
                }
            }
           
            
        }
    }
    
    @objc func checkPending(_ notification: Notification){
       updatePending()
    }
    
    func updatePending(){
        let cashflowHandler = CashFlowHandler()
               cashflowHandler.getAllTransactions { (received, sent) in
                   
                   self.sent = sent
                   self.received = received
                   let pendingTransactions = received.filter { (transaction) -> Bool in
                       return transaction.status != "Confirmed"
                   }
                   
                   
                   
                   if pendingTransactions.count > 0 {
                       self.pendingBtn.addBadge(number: pendingTransactions.count, withOffset: CGPoint(x: 0, y: 0), andColor: UIColor.appColor(.highlight) ?? .green, andFilled: true)
                   }
                   else{
                    self.pendingBtn.removeBadge()
                }
                print("Updating Pending")
               }
        
        let friendHandler = FriendHandler()
               friendHandler.getFriendRequests { (requests) in
                   if requests.count > 0 {
                    self.tabBarController?.tabBar.items?[1].badgeColor = UIColor.appColor(.highlight) ?? .green
                       self.tabBarController?.tabBar.items?[1].badgeValue = "\(requests.count)"
                   }
                   else {
                    self.tabBarController?.tabBar.items?[1].badgeValue = nil

                   }
               }
    }
    
}
