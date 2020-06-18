//
//  UsersVC.swift
//  IOU
//
//  Created by Mark Debbane on 5/7/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {
  var transaction: Transaction?
  
  @IBOutlet weak var eachTotal: UISegmentedControl!
  @IBOutlet weak var selectedUsersCollectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  
  var selectedUsers: [Friend]?
  var users: [Friend]?
  let fh: FriendHandler = FriendHandler()
  var each: Bool = true
  var searchController: UISearchController = UISearchController(searchResultsController: nil)
  
  var filteredUsers : [Friend] = []
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.selectedUsers = [] 
    navigationController?.delegate = self
    
    self.tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
    self.selectedUsersCollectionView.register(UINib(nibName: "FriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCell")
    self.selectedUsersCollectionView.delegate = self
    self.selectedUsersCollectionView.dataSource = self
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    // 1
    searchController.searchResultsUpdater = self
    // 2
    searchController.obscuresBackgroundDuringPresentation = false
    // 3
    searchController.searchBar.placeholder = "Search Friends"
    // 4
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.barTintColor = UIColor.appColor(.background)
    searchController.searchBar.tintColor = UIColor.appColor(.tabBarSelected)
    searchController.searchBar.searchBarStyle = .minimal
    // 5
    definesPresentationContext = true
    self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

    
  }
  
  
  
  func filterContentForSearchText(_ searchText: String) {
    if let users = self.users {
      filteredUsers = users.filter { (friend: Friend) -> Bool in
        return (friend.name?.lowercased().contains(searchText.lowercased()) ?? false) || (friend.email?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      
    }
    
    tableView.reloadData()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    users = []
    fh.getFriends { (friends) in
      self.users = friends
      self.tableView.reloadData()
    }
    
  }
  @IBAction func eachTotal(_ sender: Any) {
    if eachTotal.selectedSegmentIndex == 0 {
      // Each
      each = true
    }
    else{
      //Total
      each = false
    }
  }
}

extension UsersVC: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let transaction = self.transaction {
      (viewController as? AmountVC)?.transaction = transaction // Here you pass the to your original view controller
    }
  }
}

extension UsersVC: UITableViewDelegate{
  
  
}

extension UsersVC: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredUsers.count
    }
    return users?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
    
    
    if isFiltering {
      
      cell.setModelFriend(filteredUsers[indexPath.row])
      
    } else {
      if let model = users?[indexPath.row]{
        cell.setModelFriend(model)
        
      }
      
    }
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! FriendsCell
    
    if let model = cell.friendModel {
      selectedUsers?.append(model)
      print(selectedUsers?.count)

      selectedUsersCollectionView.reloadData()
    }
  }
  
}


extension UsersVC: UICollectionViewDelegate{
  
}


extension UsersVC: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return selectedUsers?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCell", for: indexPath) as! FriendsCollectionViewCell
    if let model = selectedUsers?[indexPath.row]{
      cell.setModel(model)
      
    }
    
    return cell
  }
  
  
}

extension UsersVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
    if let text = searchController.searchBar.text {
      filterContentForSearchText(text)

    }
  }
}
