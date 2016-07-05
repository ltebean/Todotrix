//
//  HomeTransition.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class HomeTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    let transition = HomeTransition()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.Push
        transition.delegate = self
        return transition
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

class HomeTransition: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    var push = true
    weak var delegate: HomeTransitionDelegate!
    var controllerToPop: UIViewController!
    
    let zoomMin = CGFloat(0.7)
    let zoomMax = CGFloat(1.5)
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let sourceView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let destinationView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        let containerView = transitionContext.containerView()!
        
        let duration = transitionDuration(transitionContext)
        
        destinationView.alpha = 0
        
        if (push) {
            destinationView.transform = CGAffineTransformMakeScale(zoomMax, zoomMax)
            controllerToPop = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            handleBack(destinationView)
        } else {
            destinationView.transform = CGAffineTransformMakeScale(zoomMin, zoomMin)
        }
        containerView.addSubview(destinationView)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
                sourceView.alpha = 0
                destinationView.alpha = 1
                if (self.push) {
                    sourceView.transform = CGAffineTransformMakeScale(self.zoomMin, self.zoomMin)
                } else {
                    sourceView.transform = CGAffineTransformMakeScale(self.zoomMax, self.zoomMax)
                }
            
                destinationView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                
                sourceView.alpha = 1
                sourceView.transform = CGAffineTransformIdentity
                destinationView.alpha = 1
                destinationView.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
            }
        )

    }
    
    func handleBack(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(HomeTransition.handlePan))
        gesture.edges = .Left
//        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func handlePan(gesture: UIScreenEdgePanGestureRecognizer) {
        let progress = gesture.translationInView(gesture.view).x / UIScreen.mainScreen().bounds.width

        if gesture.state == .Began {
            delegate.interactiveTransition = UIPercentDrivenInteractiveTransition()
            controllerToPop.navigationController?.popViewControllerAnimated(true)
        }
        else if gesture.state == .Changed {
            delegate.interactiveTransition?.updateInteractiveTransition(progress)
        }
        else if gesture.state == .Ended || gesture.state == .Cancelled {
            if progress > 0.3 {
                delegate.interactiveTransition?.finishInteractiveTransition()
            } else {
                delegate.interactiveTransition?.cancelInteractiveTransition()
            }
            delegate.interactiveTransition = nil
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
