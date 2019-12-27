//
//  UIVC_Extension.swift
//  IOU
//
//  Created by Mark on 7/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

var keyboardSizeT: CGRect?

extension UIViewController {
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? self.view.frame.origin.y)
    }
    
    func initKeyboardEvents(){
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        hideKeyboard()
    }
    
    @objc func keyboardWillShow(notification: Notification?) {
        if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           keyboardSizeT = keyboardSize
            showKeyboard()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification?) {
        if self.view.frame.origin.y != topbarHeight {
            self.view.frame.origin.y = topbarHeight
        }
    }
    
    func hideKeyboard() {
        if self.view.frame.origin.y != topbarHeight {
            self.view.frame.origin.y = topbarHeight
        }
        
    }
    
    func showKeyboard() {
        guard let keyboardSize = keyboardSizeT else{
            return
            
        }
            if self.view.frame.origin.y == topbarHeight {
                self.view.frame.origin.y -= keyboardSize.height
            }
    }
    
}

