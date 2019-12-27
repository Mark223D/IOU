//
//  IOUHomeCell.swift
//  IOU
//
//  Created by Mark on 7/8/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

class IOUHomeCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var pingButton: IOUButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueTextField: UITextField!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: ((avatarImageView.frame.height/2)+5), borderColor: UIColor.clear, borderWidth: 0.0)
        
        cellBackgroundView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 10, borderColor: UIColor.clear, borderWidth: 0.0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
