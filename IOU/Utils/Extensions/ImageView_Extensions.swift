//
//  ImageView_Extensions.swift
//  IOU
//
//  Created by Mark on 7/7/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit

extension UIImageView {
    public func maskCircle(){//}(anyImage: UIImage) {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2 
        self.layer.masksToBounds = false
        self.clipsToBounds = true

        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
//        self.image = anyImage
    }
}
