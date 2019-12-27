//
//  AlertHandler.swift
//  IOU
//
//  Created by Mark Debbane on 11/30/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import Foundation
import UIKit

class AlertHandler {
    
    private let alertTitle: String = "IOU"
    private var alertStyle: UIAlertController.Style = .alert
    private var animated: Bool = true
    
    init() {
        print("De-Initializing Alert Handler")

    }
    
    func showAlert(on vc:UIViewController, with message: String, and actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: self.alertTitle, message: message, preferredStyle: alertStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        vc.present(alertController, animated: animated, completion: nil)
    }
    
    
    deinit {
        print("De-Initializing Alert Handler")
    }
    
}

