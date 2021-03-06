//
//  FriendsCollectionViewCell.swift
//  IOU
//
//  Created by Mark Debbane on 11/25/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var model: Friend?
    
//    override var isSelected: Bool {
//        didSet {
//            self.imageView.backgroundColor = isSelected ? .red : .green
//        }
//      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setModel(_ model: Friend)
    {
        self.model = model
        self.usernameLabel.text = model.name ?? ""
        self.imageView.backgroundColor =  UIColor.appColor(.highlight)
      self.usernameLabel.textColor = UIColor.appColor(.tabBarSelected)

        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
        self.imageView.setIcon(icon: .fontAwesomeSolid(.user), textColor: .white, backgroundColor: UIColor.appColor(.highlight) ?? .orange)
    }
    


}
