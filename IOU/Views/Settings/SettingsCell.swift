//
//  SettingsCell.swift
//  IOU
//
//  Created by Mark Debbane on 4/6/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
 
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
