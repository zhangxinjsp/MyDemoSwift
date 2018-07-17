//
//  TabbarTransitionAnimation.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class TabbarTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var toLeft:Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView;
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let screenW = UIScreen.main.bounds.size.width;
        let screenH = UIScreen.main.bounds.size.height;
        
        containerView.addSubview((toView)!)
        
        fromView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
        toView?.frame = CGRect.init(x: self.toLeft ? screenW : -screenW, y: 0, width: screenW, height: screenH)
        
        containerView.bringSubview(toFront: toView!)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            fromView?.frame = CGRect.init(x: self.toLeft ? -screenW : screenW, y: 0, width: screenW, height: screenH)
            toView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
            
        }) { (complete) in
        
            fromView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
            toView?.frame   = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
