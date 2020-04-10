//
//  IOUTransCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import QuartzCore


class IOUTransCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gaveTookLabel: PillLabel!
    
    var model: CashFlow?
    var currencyFormatter: CurrencyFormatter = CurrencyFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
      gaveTookLabel.textColor = UIColor.appColor(.background)
      gaveTookLabel.layer.backgroundColor  = UIColor.appColor(.tabBarSelected)?.cgColor
      gaveTookLabel.layer.cornerRadius = gaveTookLabel.frame.height/2
//      gaveTookLabel.layer.masksToBounds = true
        
        self.avatarImageView.maskCircle()
        self.userLabel.text = "You"
        self.gaveTookLabel.isHidden = true
//        self.avatarImageView.isHidden = true
      self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height/2
      self.avatarImageView.setIcon(icon: .fontAwesomeSolid(.user), textColor: .white, backgroundColor: UIColor.appColor(.highlight) ?? .orange)
        self.userLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    
    func setModel(_ model: CashFlow, _ get: Bool){
        self.model = model
        self.avatarImageView.backgroundColor =  UIColor.appColor(.highlight)
        self.userLabel.text = model.username
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(get ?  (model.amount ?? 0) : (model.amount ?? 0) * -1)
        self.gaveTookLabel.isHidden = true
        self.avatarImageView.isHidden = false


    }
    
    func setGiveCell(_ model: Transaction){
      self.userLabel.textColor = .white
        self.userLabel.text = "GAVE"
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(model.amount ?? 0)
        self.gaveTookLabel.isHidden = false
        self.avatarImageView.isHidden = true
      
    setDateLabel(model)
      

    }
  func setDateLabel(_ model: Transaction){
    if let created  = model.created {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = .current
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = .autoupdatingCurrent
        dateFormatterPrint.dateFormat = "E dd MMM"
        
        if let date = dateFormatterGet.date(from: created) {
            
            self.gaveTookLabel.text = dateFormatterPrint.string(from: date)
          self.gaveTookLabel.padding = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        } else {
            print("There was an error decoding the string")
        }
    }
    
    
  }
    func setOweCell(_ model: Transaction){
        self.userLabel.textColor = UIColor.appColor(.highlight)
        self.userLabel.text = "TOOK"
        self.gaveTookLabel.text = "You"
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(model.amount ?? 0)
        self.gaveTookLabel.isHidden = false
        self.avatarImageView.isHidden = true
      
      
      setDateLabel(model)
        
    }
    
}
