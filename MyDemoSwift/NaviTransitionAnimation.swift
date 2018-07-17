//
//  NaviTransitionAnimation.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class NaviTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var operation:UINavigationControllerOperation = UINavigationControllerOperation.push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.3;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        let containerView = transitionContext.containerView;
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let screenW = UIScreen.main.bounds.size.width;
        let screenH = UIScreen.main.bounds.size.height;
        
        containerView.addSubview(toView!)    // 默认fromVc的视图已经加入容器内
        
        fromView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
        fromView?.transform = CGAffineTransform(scaleX: 1, y: 1);
        
        if (operation == .push) {
            containerView.sendSubview(toBack: toView!)
            toView?.frame = CGRect.init(x: -screenW * (1 - 0.8125), y: 0, width: screenW, height: screenH)
            toView?.transform = CGAffineTransform(scaleX: 0.8125, y: 0.8125)
            toView?.alpha = 1 - 0.8125;
        } else {
            containerView.bringSubview(toFront: toView!);
            fromView?.alpha = 1.0;
            
            toView?.frame = CGRect.init(x: screenW * 0.8 - screenW / 2 * (1 - 0.8125), y: 0, width: screenW, height: screenH)
            toView?.transform = CGAffineTransform(scaleX: 0.8125, y: 0.8125);
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if (self.operation == .push) {
                fromView?.frame = CGRect.init(x: screenW * 0.8 - screenW / 2 * (1 - 0.8125), y: 0, width: screenW, height: screenH)
                fromView?.transform = CGAffineTransform(scaleX: 0.8125, y: 0.8125);
                
                toView?.alpha = 1.0;
            } else {
                fromView?.frame = CGRect.init(x: -screenW * 0.2, y: 0, width: screenW, height: screenH)
                fromView?.transform = CGAffineTransform(scaleX: 0.8125, y: 0.8125);
                fromView?.alpha = 1 - 0.8125;
            }
            toView?.transform = CGAffineTransform(scaleX: 1, y: 1);
            toView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
        }) { (finished) in
            fromView?.transform = CGAffineTransform(scaleX: 1, y: 1);
            fromView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
            fromView?.alpha = 1.0;
            
            toView?.transform = CGAffineTransform(scaleX: 1, y: 1);
            toView?.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
            toView?.alpha = 1.0;
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
        }
        
        
        
    }
}
