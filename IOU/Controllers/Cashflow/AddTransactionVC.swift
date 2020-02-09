//
//  AddTransactionVC.swift
//  IOU
//
//  Created by Mark Debbane on 11/23/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class AddTransactionVC: MainVC {
    var ref: DatabaseReference!
    
    @IBOutlet weak var labelsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountTextField: IOUTextField!
    @IBOutlet weak var eachTotalSwitch: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: IOUTextField!
    
    @IBOutlet weak var descriptionTextField: IOUTextField!
    
    @IBOutlet weak var giveBtn: UIButton!
    @IBOutlet weak var takeBtn: UIButton!
    
    var selectedUsers: [Friend] = []
    var friends: [Friend] = []
    var each: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        self.initCollectionView()
        
        self.initUI()
        
        hideKeyboardWhenTapped()
    }
    
    func hideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.friends.removeAll()
        
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else { return  }
            self.ref.child("friends").child(user.uid).observe(.value) { (snapshot) -> Void in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    for snap in snapshots
                    {
                        let friend = Friend(snapshot: snap)
                        
                        if friend.status == "Confirmed" {
                            self.friends.append(friend)
                        }
                    }
                }
                self.usersCollectionView.reloadData()
                
            }
            
        }
        
    }
    
    
    @IBAction func titleEditingBegin(_ sender: Any) {
        self.view.frame.origin.y -= labelsBottomConstraint.constant*0.8
    }
    @IBAction func titleEditingEnd(_ sender: Any) {
        self.view.frame.origin.y += labelsBottomConstraint.constant*0.8
        
    }
    
    @IBAction func descriptionEditingBegin(_ sender: Any) {
        self.view.frame.origin.y -= labelsBottomConstraint.constant*0.8
        
    }
    @IBAction func descriptionEditingEnd(_ sender: Any) {
        self.view.frame.origin.y += labelsBottomConstraint.constant*0.8
        
    }
    
    @IBAction func amountEditingChanged(_ sender: Any) {
        self.amountTextField.text =  self.format(Int(self.amountTextField?.text ?? "0") ?? 0)
    }
    
    @IBAction func eachTotalChanged(_ sender: Any) {
        if eachTotalSwitch.selectedSegmentIndex == 0 {
            self.each = true
        } else {
            self.each = false
            
        }
    }
    
    @IBAction func givePressed(_ sender: Any) {
        
        self.giveBtn.isEnabled = false
        self.takeBtn.isEnabled = false
        
        guard let amount = self.amountTextField.text else { return  }
        guard let description = self.descriptionTextField.text else{ return  }
        guard let title = self.titleTextField.text else{ return  }
        
        let alertController = AlertHandler()
        let actions: [UIAlertAction] = [UIAlertAction(title: "Dismiss", style: .default, handler: nil)]
        var message: String
        
        
        if amount == "" {
            message = "Please enter amount."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else if title == "" {
            message = "Please enter title."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else if description == "" {
            message = "Please enter description."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else {
            sendTransactions(amount, title, description, true)
        }
        
//        sendTransactions(amount, title, description, true)
        
        //        self.unwind(for: "", towards: Home)
        
        
        
    }
    
    func sendTransactions(_ amount: String, _ title: String, _ description: String, _ give:Bool){
        let cashflowHandler = CashFlowHandler()
        cashflowHandler.formatTransaction(amount: amount, title: title, description: description, give: give, selectedUsers: selectedUsers, each: self.each) { (success) in
            let alertController = AlertHandler()
            let actions: [UIAlertAction] = [UIAlertAction(title: "Dismiss", style: .default, handler: nil)]
            var message: String
            
            if success {
                message = "Transaction Sent"
            }
            else{
                message = "Transaction Failed to send"
            }
            
            alertController.showAlert(on: self, with: message, and: actions)
        }
        

        self.navigationController?.popViewController(animated: true)
                   self.dismiss(animated: true) {
                       self.giveBtn.isEnabled = true
                       self.takeBtn.isEnabled = true
                   }
        
        
    }
    
    @IBAction func takePressed(_ sender: Any) {
        self.giveBtn.isEnabled = false
        self.takeBtn.isEnabled = false
        
        guard let amount = self.amountTextField.text else { return  }
        guard let description = self.descriptionTextField.text else { return  }
        guard let title = self.titleTextField.text else{ return  }
        
        
        let alertController = AlertHandler()
        let actions: [UIAlertAction] = [UIAlertAction(title: "Dismiss", style: .default, handler: nil)]
        var message: String
        
        
        if amount == "" {
            message = "Please enter amount."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else if title == "" {
            message = "Please enter title."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else if description == "" {
            message = "Please enter description."
            alertController.showAlert(on: self, with: message, and: actions)

        }
        else {
            sendTransactions(amount, title, description, false)
        }
    }
    
}

extension AddTransactionVC:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendsCollectionViewCell
        cell.imageView.backgroundColor = .red
        if let model = cell.model{
            self.selectedUsers.append(model)
        }
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
}

extension AddTransactionVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCell", for: indexPath) as! FriendsCollectionViewCell
        
        cell.setModel(self.friends[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let indexPaths = collectionView.indexPathsForSelectedItems, indexPaths.contains(indexPath) {
            
            return false
        }
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FriendsCollectionViewCell
        let model = cell.model
        if let id = model?.id{
            self.selectedUsers.removeAll { (unselected) -> Bool in
                unselected.id == id
            }
            
        }
        cell.imageView.backgroundColor = .green
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    
    
    
    
    
}
extension AddTransactionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.height * 0.5, height: collectionView.frame.height * 0.8)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 4, bottom: 0, right: 4)
    }
}


extension AddTransactionVC {
    func initUI(){
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        eachTotalSwitch.setTitleTextAttributes(titleTextAttributes, for: .normal)
        eachTotalSwitch.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        amountTextField.textColor = .white
        titleTextField.textColor = .white
        descriptionTextField.textColor = .white
        
        amountTextField.attributedPlaceholder =
            NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGrey])
        
        titleTextField.attributedPlaceholder =
            NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGrey])
        
        descriptionTextField.attributedPlaceholder =
            NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGrey])
        
        let textField = searchBar.searchTextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = .lightGrey
        
        self.view.bounds = view.frame.insetBy(dx: 0.0, dy: 10.0)

    }
    
    func initCollectionView() {
        self.usersCollectionView.allowsMultipleSelection = true
        self.usersCollectionView.delegate = self
        self.usersCollectionView.dataSource = self
        self.usersCollectionView.register(UINib(nibName: "FriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCell")
        
    }
}
