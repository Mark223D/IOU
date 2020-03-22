//
//  Colors.swift
//  IOU
//
//  Created by Mark Debbane on 3/22/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import Foundation
import UIKit

enum AssetsColor : String {
  case background
  case foreground
  case highlight
  case highlightDark
  case highlightLight
  case tabBarSelected
}
extension UIColor {
  static func appColor(_ name: AssetsColor) -> UIColor? {
     return UIColor(named: name.rawValue)
  }
}
