//
//  IOUExpandedTransCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import Firebase

class IOUExpandedTransCell: UITableViewCell {
    
    @IBOutlet weak var gaveTookLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    var gave:Bool = true
    
    var model: Transaction?
    
    let currencyFormatter: CurrencyFormatter = CurrencyFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backView.layer.cornerRadius = 20
        self.timeLabel.text = ""
        
    }
    
    func setModel(_ model: Transaction, _ user: User, _ name: String)
    {
        self.model = model
        
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(model.amount ?? 0)
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        
        if let created  = model.created {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.timeZone = .current
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.timeZone = .autoupdatingCurrent
            dateFormatterPrint.dateFormat = "E, dd MMM yyyy @ h:mm a"
            
            if let date = dateFormatterGet.date(from: created) {
                
                self.dateLabel.text = dateFormatterPrint.string(from: date)
                
            } else {
                print("There was an error decoding the string")
            }
        }
        
        
        if model.giver == user.uid {
            //User is giver
            self.gaveTookLabel.text = "You Gave \(name)"
//            self.backView.backgroundColor = .green
        }
        else {
            //User is taker
            self.gaveTookLabel.text = "\(name) Gave You"
//            self.backView.backgroundColor = .red
        }
      self.backView.backgroundColor = UIColor.appColor(.foreground)
    }
    
}
