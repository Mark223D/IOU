//
//  PendingTransactionsVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/26/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class PendingTransactionsVC: MainVC {
    
    private let screenSize: CGRect = UIScreen.main.bounds
    private var lastContentOffset: CGFloat = 0
    
    private var lists: [UITableView] = []
     var sent : [Transaction] = []
     var received: [Transaction] = []
    private var friends: [Friend] = []
    
    private var selectedContent:Transaction?
    private var ref:DatabaseReference!
    
    
    private let titles = [
        "Received",
        "Sent",
    ]
    
    lazy var viewPager: WormTabStrip = {
        let frame =  CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: self.view.frame.size.height - 8)
        
        let view = WormTabStrip(frame: frame)
        view.delegate = self
        view.eyStyle.wormStyel = .BUBBLE
        view.eyStyle.isWormEnable = false
        view.eyStyle.spacingBetweenTabs = 15
      view.eyStyle.dividerBackgroundColor = UIColor.appColor(.foreground) ?? .blue
      view.eyStyle.topScrollViewBackgroundColor = UIColor.appColor(.foreground) ?? .blue
        view.eyStyle.tabItemSelectedColor = .white
      view.eyStyle.WormColor = UIColor.appColor(.highlight) ?? .orange

        view.currentTabIndex = 0
        view.shouldCenterSelectedWorm = false
        view.buildUI()
        
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(viewPager)
        var i = 0
        for table in self.lists{
            table.tag = i
            i += 1
        }
        
        self.view.bounds = view.frame.insetBy(dx: 0.0, dy: 10.0)

        NotificationCenter.default.addObserver(self, selector: #selector(self.callGetData(_:)), name: .updatePending, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.getFriends()

        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeVC {
            
        }
    }
    
    
    @objc func callGetData(_ notification: Notification){
       self.getFriends()

        self.getData()
    }
    func getFriends()
    {
      let friendHandler = FriendHandler()
        friendHandler.getFriends { (friends) in
            self.friends = friends
            for table in self.lists{
                table.reloadData()
            }
        }
    }
    func getData(){
        let cashflowHandler = CashFlowHandler()
        cashflowHandler.getAllTransactions { (received, sent) in
            self.sent.removeAll()
            self.sent.removeAll()
            self.sent = sent
            self.received = received
            for table in self.lists{
                table.reloadData()
            }
        }
        
        
    }
    
    
    
    
    
    
}


extension PendingTransactionsVC: UITableViewDelegate {
    
}

extension PendingTransactionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.received.count
        }
        else{
            return self.sent.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingCell") as! PendingCell
        
        if tableView.tag == 0 {
            if received.count > 0{
                let list = self.friends.filter({ (friend) -> Bool in
                    (friend.id == self.received[indexPath.row].sender!)
                })
                
                if let first = list.first {
                    cell.setModel(self.received[indexPath.row], first)
                    
                }
            }
            
        }
        else{
            if sent.count > 0{
                let list = self.friends.filter({ (friend) -> Bool in
                    (friend.id == self.sent[indexPath.row].receiver!) || (friend.id == self.sent[indexPath.row].giver!)
                })
                if let first = list.first {
                    cell.setModel(self.sent[indexPath.row], first)
                    
                }            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.3
    }
    
    
}


extension PendingTransactionsVC: WormTabStripDelegate{
    func WTSNumberOfTabs() -> Int {
        return self.titles.count
    }
    
    func WTSViewOfTab(index: Int) -> UIView {
        let tabPageX = self.view.frame.origin.x
        let tabPageY = self.view.frame.origin.y + 8
        let tabPageW = self.view.frame.width
        let tabPageH = self.view.frame.height - 110
        
        let view = UIView(frame: CGRect(x: tabPageX, y: tabPageY , width: tabPageW, height: tabPageH))
        
        
        let tableView = UITableView(frame: CGRect(x: tabPageX, y: tabPageY, width: tabPageW, height: tabPageH))
        tableView.tag = index
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: "PendingCell")
        
        view.addSubview(tableView)
        self.lists.append(tableView)
        
        return view
    }
    
    func WTSTitleForTab(index: Int) -> String {
        
        return titles[index]
    }
    
    func WTSReachedLeftEdge(panParam: UIPanGestureRecognizer) {
    }
    
    func WTSReachedRightEdge(panParam: UIPanGestureRecognizer) {
    }
    
}
