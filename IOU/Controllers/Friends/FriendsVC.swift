//
//  FriendsVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/6/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class FriendsVC: MainVC, UIScrollViewDelegate {
  
  var user: User!
  var currentFriends: [Friend] = []
  var ref: DatabaseReference!
  
  var friends: [Friend] = []
  
  var searchActive = false
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addFriendBtn: UIBarButtonItem!
  
  let search = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.initUI()
    
    self.ref = Database.database().reference()
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRequests(_:)), name: .checkRequest, object: nil)
    
    self.tabBarItem.image = UIImage(named: "friends")
    
    if traitCollection.userInterfaceStyle == .light {
      print("Light mode")
      self.tabBarItem.selectedImage = UIImage(named: "friends-active-blue")
    } else {
      print("Dark mode")
      self.tabBarItem.selectedImage = UIImage(named: "friends-active-white")
      
    }
    setupSearchBar()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationItem.hidesSearchBarWhenScrolling = true

  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    getFriends()
    checkPending()
    self.addFriendBtn.setIcon(icon: .fontAwesomeSolid(.userPlus), iconSize: 20.0, color: .white)
    self.addFriendBtn.tintColor = .white //UIColor.appColor(.highlight)
    navigationItem.hidesSearchBarWhenScrolling = false

    
  }
  
  func getFriends(){
    self.friends.removeAll()
    self.currentFriends.removeAll()
    
    let firebase = NetworkHandler()
    
    firebase.setupFirebaseCall { (user) in
      
      let friendHandler = FriendHandler()
      
      friendHandler.getFriends { (friends) in
        
        self.friends = friends
        self.currentFriends = friends
        self.tableView.reloadData()
        
      }
    }
  }
  
  func setupSearchBar(){

        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        search.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = search
        let textField = search.searchBar.searchTextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.appColor(.tabBarSelected) ?? .green
    
    
    
  }
  
  func checkPending(){
    let friendHandler = FriendHandler()
    friendHandler.getFriendRequests { (requests) in
        //Badge Code
    }
  }
  
  
  @objc func checkRequests(_ notification: Notification){
    checkPending()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty  else {
      currentFriends = friends
      tableView.reloadData()
      
      return
      
    }
    
    currentFriends = friends.filter({ friend -> Bool in
      return friend.name!.lowercased().contains(searchText.lowercased())
    })
    
    tableView.reloadData()
    
  }
  
}


extension FriendsVC: UITableViewDelegate {
  
}

extension FriendsVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.currentFriends.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: FriendsCell = self.tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
    if self.currentFriends.count > 0 {
      cell.setModelFriend(self.currentFriends[indexPath.row])
      
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return tableView.frame.size.height/8
    
  }
  
}

extension FriendsVC {
  
  func initUI(){
    
    self.tabBarItem.image = UIImage(named: "friends")
    

    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
    self.hideKeyboardWhenTappedAround()
    self.tableView.backgroundColor = .clear
    self.view.backgroundColor = UIColor.appColor(.background)
    self.navigationController?.setStatusBar(backgroundColor: UIColor.appColor(.foreground) ?? .green)
    
    
  }
  
}


extension FriendsVC: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
}
