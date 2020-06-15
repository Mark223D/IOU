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
  
  var lastIndex = 0
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
    animateToAdd(toIndex: 2)

  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    guard let tabViewControllers = tabBarController.viewControllers,
      let toIndex = tabViewControllers.firstIndex(of: viewController) else {
          return false
      }
    let fromIndex = self.selectedIndex
    
    if toIndex == 2 {
//      lastIndex = fromIndex
      animateToAdd(toIndex: toIndex)
    }
    else if fromIndex == 2 {
      animateFromAdd(toIndex: lastIndex)
    }
      return true
  }

  func animateToAdd(toIndex: Int) {
      guard let tabViewControllers = viewControllers//,
//          let selectedVC = selectedViewController
        else { return }

    guard let fromView = self.view,
          let toView = tabViewControllers[toIndex].view
//        let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
//        fromIndex != toIndex
        else { return }


      // Add the toView to the tab bar view
      fromView.superview?.addSubview(toView)

      // Position toView off screen (to the up/down of fromView)
      let screenHeight = UIScreen.main.bounds.size.height
      let scrollUp = toIndex == 2
      let offset = (scrollUp ? screenHeight : -screenHeight)
      toView.center = CGPoint(x: fromView.center.x , y: toView.center.y + offset)

      // Disable interaction during animation
      view.isUserInteractionEnabled = false

    UIView.animate(withDuration: 1.0,
                     delay: 0.0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 0,
                     options: .curveEaseOut,
                     animations: {
                      // Slide the views by -offset
                      fromView.center = CGPoint(x: fromView.center.x, y: fromView.center.y - offset)
                      toView.center = CGPoint(x: toView.center.x, y: toView.center.y - offset)

      }, completion: { finished in
          // Remove the old view from the tabbar view.
          self.selectedIndex = toIndex
          self.view.isUserInteractionEnabled = true
      })
  }
func leaveAdd() {
  animateFromAdd(toIndex: lastIndex)
  }
  
  func animateFromAdd(toIndex: Int) {
    
    print(toIndex)
        guard let tabViewControllers = viewControllers
//            let selectedVC = selectedViewController
          else { return }

      guard let fromView = self.view,
        let toView = tabViewControllers[toIndex].view
//          let fromIndex = tabViewControllers.firstIndex(of: selectedVC),fromIndex != toIndex
        else { return }

    
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)

        // Position toView off screen (to the up/down of fromView)
        let screenHeight = UIScreen.main.bounds.size.height
        let scrollDown = self.selectedIndex == 2
        let offset = (scrollDown ? -screenHeight : screenHeight)
        toView.center = CGPoint(x: fromView.center.x , y: toView.center.y - offset)

        // Disable interaction during animation
        view.isUserInteractionEnabled = false

      UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by +offset
                        fromView.center = CGPoint(x: fromView.center.x, y: fromView.center.y + offset)
                        toView.center = CGPoint(x: toView.center.x, y: toView.center.y + offset)

        }, completion: { finished in
print(toIndex)
            // Remove the old view from the tabbar view.
            self.selectedIndex = toIndex
            
            self.view.isUserInteractionEnabled = true
        })
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
