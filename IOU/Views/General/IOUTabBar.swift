//
//  IOUTabBar.swift
//  IOU
//
//  Created by Mark Debbane on 4/5/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import Foundation
import UIKit
import SwiftIcons

class IOUTabBarCtrl: UITabBarController, UITabBarControllerDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
      setupMiddleButton()
   }
  
  func setupMiddleButton() {

         let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
         
         //STYLE THE BUTTON YOUR OWN WAY
         middleBtn.setIcon(icon: .fontAwesomeSolid(.plus), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
//      middleBtn.applyGradient(colors: [UIColor.appColor(.highlightDark),UIColor.appColor(.highlightLight)])
    middleBtn.backgroundColor = UIColor.appColor(.highlight)
    middleBtn.layer.cornerRadius = middleBtn.layer.frame.height/2
         //add to the tabbar and add click event
         self.tabBar.addSubview(middleBtn)
         middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

         self.view.layoutIfNeeded()
     }

     // Menu Button Touch Action
     @objc func menuButtonAction(sender: UIButton) {
         self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
     }
}


@IBDesignable
class IOUTabBar: UITabBar {
  private var shapeLayer: CALayer?
  private func addShape() {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = createPath()
      shapeLayer.strokeColor = UIColor.lightGray.cgColor
      shapeLayer.fillColor = UIColor.white.cgColor
      shapeLayer.lineWidth = 1.0
      
      //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
      shapeLayer.shadowOffset = CGSize(width:0, height:0)
      shapeLayer.shadowRadius = 10
      shapeLayer.shadowColor = UIColor.gray.cgColor
      shapeLayer.shadowOpacity = 0.3

      if let oldShapeLayer = self.shapeLayer {
          self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
      } else {
          self.layer.insertSublayer(shapeLayer, at: 0)
      }
      self.shapeLayer = shapeLayer
  }
  override func draw(_ rect: CGRect) {
      self.addShape()
  }
  func createPath() -> CGPath {
      let height: CGFloat = 37.0
      let path = UIBezierPath()
      let centerWidth = self.frame.width / 2
      path.move(to: CGPoint(x: 0, y: 0)) // start top left
      path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

      path.addCurve(to: CGPoint(x: centerWidth, y: height),
      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))

      path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

      path.addLine(to: CGPoint(x: self.frame.width, y: 0))
      path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
      path.addLine(to: CGPoint(x: 0, y: self.frame.height))
      path.close()

      return path.cgPath
  }
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
      for member in subviews.reversed() {
          let subPoint = member.convert(point, from: self)
          guard let result = member.hitTest(subPoint, with: event) else { continue }
          return result
      }
      return nil
  }
}