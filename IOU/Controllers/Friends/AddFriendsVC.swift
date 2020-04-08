//
//  AddFriendsVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class AddFriendsVC: MainVC {
    
    var user: IOUUser!
    var items: [IOUUser] = []
    var ref: DatabaseReference!
    var searchActive: Bool = false
    let search = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        self.initUI()
        self.hideKeyboardWhenTappedAround()
      setupSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
      self.title = "Add Friends"
      navigationItem.hidesSearchBarWhenScrolling = false

        
    }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationItem.hidesSearchBarWhenScrolling = true

  }
    
    func searchQueryUsers(text: String) {
        let firebase = NetworkHandler()
        
        firebase.setupFirebaseCall { (user) in
            
            let friendHandler = FriendHandler()
            
            friendHandler.searchUser(text) { (users) in
                
                self.items = users
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    
    func showAlert(_ message: String, _ selectedUser: IOUUser) {
        
        let alertHandler = AlertHandler()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            self.sendFriendRequest(to: selectedUser)
        })
        
        alertHandler.showAlert(on: self, with: message, and: [cancelAction, confirmAction])
        
    }
    
    
    func sendFriendRequest(to selectedUser: IOUUser){
        
        let firebase = NetworkHandler()
        firebase.setupFirebaseCall { (user) in
            
            let friendHandler = FriendHandler()
            friendHandler.sendFriendRequest(selectedUser) {(success) in
                
                let alertHandler = AlertHandler()
                let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                if success{
                    alertHandler.showAlert(on: self, with: "Friend Request Sent", and: [action])
                }
            }
        }
    }
}



extension AddFriendsVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsCell
        
        self.showAlert("Send \(cell.nameLabel.text ?? "") a friend request.", self.items[indexPath.row])
    }
}
extension AddFriendsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FriendsCell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        
        cell.setModelUser(self.items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height/8
        
    }
    
}


extension AddFriendsVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.items.removeAll()
        self.tableView.reloadData()
        
        if searchText != "" {
            self.searchQueryUsers(text: searchText)
        }
    }
}


extension AddFriendsVC {
    
    func initUI(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        
      self.navigationItem.rightBarButtonItem?.setIcon(icon: .fontAwesomeSolid(.userPlus), iconSize: 32.0)
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
    
}
