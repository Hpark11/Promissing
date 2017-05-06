//
//  ExpandingAnimator.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 6..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

class ExpandingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionMode: Int {
        case present, dismiss
    }
    
    var transitionMode: TransitionMode = .present
    var circle: UIView?
    var circleColor: UIColor?
    
    var origin = CGPoint.zero
    let presentDuration = 0.8
    let dismissDuration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if transitionMode == .present {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func frameForCircle(center: CGPoint, size: CGSize, start:CGPoint) -> CGRect {
        let lengthX = fmax(start.x, size.width - start.x);
        let lengthY = fmax(start.y, size.height - start.y);
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width:offset, height: offset)
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            
            // Get view of view controller Being presented
            let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let originalCenter = presentedView.center
            let originalSize = presentedView.frame.size
            
            // Get frame of circle
            circle = UIView(frame: frameForCircle(center: originalCenter, size: originalSize, start: origin))
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center = origin
            
            // Make it very small
            circle!.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            
            // Set the background color
            circle!.backgroundColor = circleColor
            
            // Add Circle to container view
            containerView.addSubview(circle!)
            
            // Make presented view very small and transparent
            presentedView.center = origin
            presentedView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            
            // Set the background color
            presentedView.backgroundColor = circleColor
            
            // Add presented view to container view
            containerView.addSubview(presentedView)
            
            // Animate both views
            UIView.animate(withDuration: presentDuration, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { 
                self.circle!.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                presentedView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                presentedView.center = originalCenter
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        } else {
            let returningControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            circle!.frame = frameForCircle(center: originalCenter, size: originalSize, start: origin)
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center = origin
            
            UIView.animate(withDuration: dismissDuration, animations: {
                self.circle!.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
                returningControllerView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.origin
                returningControllerView.alpha = 0
            }) { (_) -> Void in
                returningControllerView.removeFromSuperview()
                self.circle!.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
