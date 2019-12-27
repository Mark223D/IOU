//
//  AnimationEngine.swift
//  IOU
//
//  Created by Mark on 7/5/19.
//  Copyright © 2019 IOU. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    class var offScreenTopPosition: CGPoint{
        return CGPoint(x: UIScreen.main.bounds.midX, y: -UIScreen.main.bounds.height)
    }
    
    class var offScreenBottomPosition: CGPoint{
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height)
    }
    
    class var offScreenRightPosition: CGPoint{
        return CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
    }
    
    class var offScreenLeftPosition: CGPoint{
        return CGPoint(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY )
    }
    
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]!
    let ANIM_DELAY: Int =  1
    
    init(constraints: [NSLayoutConstraint]) {
        for con in constraints {
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenBottomPosition.y
        }
        self.constraints = constraints
    }
    func animateOnScreen(delay: Int64?, completion: @escaping () -> ()) {
        let d: Int64 = delay == nil ? Int64(Double(ANIM_DELAY) * Double(NSEC_PER_SEC)) : delay!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(d)) {
//        var index = 0
//            
//            
//            repeat{
//                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
//                moveAnim?.toValue = self.originalConstants[index]
//                
//                moveAnim?.springBounciness = 5
//                moveAnim?.springSpeed = 5
//                
//                let con = self.constraints[index]
//                con.pop_add(moveAnim, forKey: "moveOnScreen")
//                index += 1
//            } while (index < self.constraints.count)
//            
            completion()

        }
    
    }
}
