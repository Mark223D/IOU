//
//  IOUTransCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/14/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

class IOUTransCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gaveTookLabel: UILabel!
    
    var model: CashFlow?
    var currencyFormatter: CurrencyFormatter = CurrencyFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarImageView.maskCircle()
        self.userLabel.text = "You"
        self.gaveTookLabel.isHidden = true
        self.avatarImageView.isHidden = true

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
        self.userLabel.textColor = .green
        self.userLabel.text = "GAVE"
        self.gaveTookLabel.text = "You"
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(model.amount ?? 0)
        self.gaveTookLabel.isHidden = false
        self.avatarImageView.isHidden = true

    }
    
    func setOweCell(_ model: Transaction){
        self.userLabel.textColor = .red
        self.userLabel.text = "TOOK"
        self.gaveTookLabel.text = "You"
        self.amountLabel.text = currencyFormatter.formatAmountToLBP(model.amount ?? 0)
        self.gaveTookLabel.isHidden = false
        self.avatarImageView.isHidden = true

        
    }
    
}
