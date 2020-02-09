//
//  ViewController.swift
//  IOU
//
//  Created by Mark on 7/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import pop
import Firebase


class LoginVC: MainVC {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var emailTextField: IOUTextField!
    @IBOutlet private weak var passwordTextField: IOUTextField!
    @IBOutlet private weak var signinBtn: IOUButton!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var fieldsStackView: UIStackView!
    @IBOutlet private weak var registerStackView: UIStackView!
    
    private var firstLoad = true
    private var editingField:Int = 0
    private var animEngine: AnimationEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
        self.initKeyboardEvents()
        
        self.initAnimationEngine()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if let user = Auth.auth().currentUser {
            let token = Messaging.messaging().fcmToken

            let ref = Database.database().reference()
            NetworkHandler().getUser(user.uid) { (test) in
                 ref.child("users")
                            .child(user.uid)
                            .setValue([
                                "id": user.uid,
                                "email": test.email,
                                "firstName": test.firstName,
                                "lastName": test.lastName,
                                "pushToken": token
                            ])
            }
            
            self.performSegue(withIdentifier: "toHomeSegue", sender: self)
        }
    }
    
    
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        signin()
        
    }
    
    @IBAction func emailEditingBegin(_ sender: Any) {
        editingField = 0
    }
    
    
    @IBAction func passwordEditingBegin(_ sender: Any) {
        editingField = 1
    }
    
}

/*
 MARK: - TextFieldDelegate Extension
 */

extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performAction(textField)
        return true
    }
    
    func performAction(_ textField: UITextField) {
        if(editingField == 0)
        {
            passwordTextField.becomeFirstResponder()
        }
        else if(editingField == 1)
        {
            passwordTextField.resignFirstResponder()
            signin()
        }
    }
}


extension LoginVC {
    
    /*
     MARK: - UI Initialization
     */
    
    func initUI(){
        self.logoImageView.layer.cornerRadius = 5
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.signinBtn.titleText = "Log In"
        
        self.loader.isHidden = true
        self.loader.hidesWhenStopped = true
    }
    
    
    func toggleFields(to bool: Bool){
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        signinBtn.isEnabled = bool
    }
    
    func initAnimationEngine(){
        self.animEngine = AnimationEngine(constraints: [ ])
    }
    
    /*
     MARK: - User Sign In Handlers Functions
     */
    func signin(){
        
        if dataIsValid() {
            loader.isHidden = false
            loader.startAnimating()
            
            toggleFields(to: false)
            
            guard let email = emailTextField.text else {
                return
            }
            guard let password = passwordTextField.text else {
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                self.loader.stopAnimating()
                
                if let signInError = error {
                    self.handleSignInError(error: signInError)
                }
                else{
                    self.performSegue(withIdentifier: "toHomeSegue", sender: self)
                }
                
            })
        }
        toggleFields(to: true)
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
        
        return valid
    }
    
    
    func handleSignInError(error: Error){
        let alertHandler = AlertHandler()
        let action = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .networkError:
                alertHandler.showAlert(on: self, with: "Network Error. Please check your internet connection and try again.", and: [action])
            case .userNotFound:
                alertHandler.showAlert(on: self, with: "User not found. Register Now!", and: [action])
            case .wrongPassword:
                alertHandler.showAlert(on: self, with: "Incorrect Username or Password", and: [action])
            default:
                alertHandler.showAlert(on: self, with: "Error: \(error.localizedDescription)", and: [action])
            }
        }
        return
    }
    
    
    
}
