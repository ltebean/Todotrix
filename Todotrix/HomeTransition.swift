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
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.push = operation == UINavigationControllerOperation.push
        transition.delegate = self
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

class HomeTransition: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    var push = true
    weak var delegate: HomeTransitionDelegate!
    var controllerToPop: UIViewController!
    
    let zoomMin = CGFloat(0.7)
    let zoomMax = CGFloat(1.5)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let sourceView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let destinationView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        
        destinationView?.alpha = 0
        
        if (push) {
            destinationView?.transform = CGAffineTransform(scaleX: zoomMax, y: zoomMax)
            controllerToPop = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            handleBack(destinationView!)
        } else {
            destinationView?.transform = CGAffineTransform(scaleX: zoomMin, y: zoomMin)
        }
        containerView.addSubview(destinationView!)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
                sourceView?.alpha = 0
                destinationView?.alpha = 1
                if (self.push) {
                    sourceView?.transform = CGAffineTransform(scaleX: self.zoomMin, y: self.zoomMin)
                } else {
                    sourceView?.transform = CGAffineTransform(scaleX: self.zoomMax, y: self.zoomMax)
                }
            
                destinationView?.transform = CGAffineTransform.identity
            }, completion: { finished in
                
                sourceView?.alpha = 1
                sourceView?.transform = CGAffineTransform.identity
                destinationView?.alpha = 1
                destinationView?.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            }
        )

    }
    
    func handleBack(_ view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(HomeTransition.handlePan))
        gesture.edges = .left
//        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func handlePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let progress = gesture.translation(in: gesture.view).x / UIScreen.main.bounds.width

        if gesture.state == .began {
            delegate.interactiveTransition = UIPercentDrivenInteractiveTransition()
            controllerToPop.navigationController?.popViewController(animated: true)
        }
        else if gesture.state == .changed {
            delegate.interactiveTransition?.update(progress)
        }
        else if gesture.state == .ended || gesture.state == .cancelled {
            if progress > 0.3 {
                delegate.interactiveTransition?.finish()
            } else {
                delegate.interactiveTransition?.cancel()
            }
            delegate.interactiveTransition = nil
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
