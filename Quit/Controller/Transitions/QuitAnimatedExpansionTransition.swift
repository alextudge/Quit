//
//  QuitAnimatedExpansionTransition.swift
//  Quit
//
//  Created by Alex Tudge on 18/05/2019.
//  Copyright © 2019 Alex Tudge. All rights reserved.
//

import UIKit

class QuitAnimatedExpansionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.75
    var presenting = true
    var originFrame = CGRect.zero
    
    // If an action needs to be completed on dismiss of the presented view controller, user this completion block
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get references to the appropriate views
        let containerView = transitionContext.containerView
        let actualCoordinatorToView = transitionContext.view(forKey: .to)!
        let viewToPresent = presenting ? actualCoordinatorToView : transitionContext.view(forKey: .from)!
        
        // Get the frames we are aniamting from/to
        let initialFrame = presenting ? originFrame : viewToPresent.frame
        let finalFrame = presenting ? viewToPresent.frame : originFrame
        
        // Setup the ratios needed to complete the transition from each of these controllers
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        // If we're presenting, setup the view which will be presented
        if presenting {
            viewToPresent.transform = scaleTransform
            viewToPresent.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            viewToPresent.clipsToBounds = true
        }
        
        // Arramge the controllers within the transition context container
        containerView.addSubview(actualCoordinatorToView)
        containerView.bringSubviewToFront(viewToPresent)
        
        // Animate to the new positions, and if we're dismissing fullfill the completion block
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: presenting ? 0.7 : 0.8, initialSpringVelocity: 0.3,
                       animations: {
                        viewToPresent.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        viewToPresent.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        if !self.presenting {
                            viewToPresent.alpha = 0
                        }
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}
