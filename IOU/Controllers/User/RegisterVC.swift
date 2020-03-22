//
//  RegisterViewController.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: MainVC {
        
    @IBOutlet weak private var emailTextField: IOUTextField!
    @IBOutlet weak private var firstnameTextField: IOUTextField!
    @IBOutlet weak private var lastnameTextfield: IOUTextField!
    @IBOutlet weak private var passwordTextField: IOUTextField!
    @IBOutlet weak private var registerBtn: IOUButton!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    
    private var editingField: Int = 0
    private var ref: DatabaseReference!

 
  
  override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
                 self.navigationController?.navigationBar.barTintColor = UIColor.appColor(.foreground)
    self.navigationController?.navigationBar.backgroundColor = UIColor.appColor(.foreground)

   }
  override func viewDidLoad() {
        super.viewDidLoad()
       
        self.ref = Database.database().reference()
        
        self.initUI()
        
        self.hideKeyboardWhenTappedAround()

    }



    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      self.navigationController?.setStatusBar(backgroundColor: UIColor.appColor(.background) ?? .green)


    }
    @IBAction func emailEditingBegin(_ sender: Any) {
        editingField = 0
    }
    
    @IBAction func firstnameEditingBegin(_ sender: Any) {
        editingField = 1
    }
    
    @IBAction func lastnameEditingBegin(_ sender: Any) {
        editingField = 2
        showKeyboard()
    }
    
    @IBAction func passwordEditingBegin(_ sender: Any) {
        editingField = 3
        showKeyboard()
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        register()
    }
}


extension RegisterVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performAction(textField)
        return true
    }
    
    func performAction(_ textField: UITextField) {
        
        switch editingField {
        case 0:
            firstnameTextField.becomeFirstResponder()
        case 1:
            lastnameTextfield.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
        case 3:
            passwordTextField.resignFirstResponder()
            register()
        default:
            return
        }
        
    }
}

extension RegisterVC {
    
    func initUI(){
        
        self.registerBtn.titleText = "Register"
        self.emailTextField.delegate = self
        self.firstnameTextField.delegate = self
        self.lastnameTextfield.delegate = self
        self.passwordTextField.delegate = self
        self.loader.hidesWhenStopped = true
    }
    
    func register(){
        
        if dataIsValid(){
            
            loader.isHidden = false
            loader.startAnimating()
            
            toggleFields(to: false)
            
            guard let email = emailTextField.text else { return  }
            guard let password = passwordTextField.text else { return  }
            guard let firstName = firstnameTextField.text else { return  }
            guard let lastName = lastnameTextfield.text else { return  }
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                self.loader.stopAnimating()
                
                if let error = error {
                    self.handleSignInError(error: error)
                    self.toggleFields(to: true)
                    return
                }
                
                /*
                     MARK: - Saving User in DB
                 */
                
                self.ref.child("users")
                    .child(user!.user.uid)
                    .setValue([
                        "id": user!.user.uid,
                        "email": email,
                        "firstName": firstName,
                        "lastName": lastName
                    ])
                
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }
        else {
            toggleFields(to: true)
        }
        
    }
    
    func handleSignInError(error: Error){
        let alertHandler = AlertHandler()
        let alertAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil)
        
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .invalidEmail:
                alertHandler.showAlert(on: self, with: "Enter a valid email.", and: [alertAction])
            case .emailAlreadyInUse:
                alertHandler.showAlert(on: self, with: "Email already in use.", and: [alertAction])
            default:
                alertHandler.showAlert(on: self, with: "Error: \(error.localizedDescription)", and: [alertAction])
            }
        }
    }
    func toggleFields(to bool: Bool){
        
        self.emailTextField.isEnabled = bool
        self.passwordTextField.isEnabled = bool
        self.firstnameTextField.isEnabled = bool
        self.lastnameTextfield.isEnabled = bool
        self.registerBtn.isEnabled = bool
        
    }
    
    
    func dataIsValid() -> Bool {
        var valid: Bool = true
        
        if emailTextField.isEmpty()
        {
            valid = !valid
            emailTextField.shake()
        }
        
        if passwordTextField.isEmpty()
        {
            valid = !valid
            passwordTextField.shake()
        }
        if firstnameTextField.isEmpty()
        {
            valid = !valid
            firstnameTextField.shake()
        }
        
        if lastnameTextfield.isEmpty()
        {
            valid = !valid
            firstnameTextField.shake()
        }
        
        return valid
    }
    
}
