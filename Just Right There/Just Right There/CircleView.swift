//
//  CircleView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 3/6/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var circle = UIView()
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetCircle()
        addSubview(circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetCircle() {
        
        var rectSide: CGFloat = 0
        if (frame.size.width > frame.size.height) {
            rectSide = frame.size.height
        } else {
            rectSide = frame.size.width
        }
        
        let circleRect = CGRect(x: (frame.size.width-rectSide)/2, y: (frame.size.height-rectSide)/2, width: rectSide, height: rectSide)
        circle = UIView(frame: circleRect)
        circle.backgroundColor = UIColor.yellow
        circle.layer.cornerRadius = rectSide/2
        circle.layer.borderWidth = 2.0
        circle.layer.borderColor = UIColor.red.cgColor
    }
    
    func resizeCircle (summand: CGFloat) {
        
        frame.origin.x -= summand/2
        frame.origin.y -= summand/2
        
        frame.size.height += summand
        frame.size.width += summand
        
        circle.frame.size.height += summand
        circle.frame.size.width += summand
    }
    
    func animateChangingCornerRadius (toValue: Any?, duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = circle.layer.cornerRadius
        animation.toValue =  toValue
        animation.duration = duration
        circle.layer.cornerRadius = self.circle.frame.size.width/2
        circle.layer.add(animation, forKey:"cornerRadius")
    }
    
    
    func circlePulseAinmation(_ summand: CGFloat, duration: TimeInterval, completionBlock:@escaping ()->()) {
        
        UIView.animate(withDuration: duration, delay: 0,  options: .curveEaseInOut, animations: {
            self.resizeCircle(summand: summand)
        }) { _ in
            completionBlock()
        }
        
        animateChangingCornerRadius(toValue: circle.frame.size.width/2, duration: duration)
        
    }
    
    func resizeCircleWithPulseAinmation(_ summand: CGFloat,  duration: TimeInterval) {
        
        if (!isAnimating) {
            isAnimating = true
            circlePulseAinmation(summand, duration:duration) {
                self.circlePulseAinmation((-1)*summand, duration:duration) {self.isAnimating = false}
            }
        }
    }
}
