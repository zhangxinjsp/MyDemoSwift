//
//  TabBarController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2017/3/24.
//  Copyright © 2017年 张鑫. All rights reserved.
//

import UIKit

enum TabbarItemTag: Int {
    case UI
    case third
    case function
    case tools
}

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func loadView() {
        super.loadView()
//        String str = str
//        print("\(type(of: self)) \(#function) line: \(#line)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
//        self.tabBar.delegate = self
        
        let UIctl = MyUIMenuViewController()
        UIctl.title = NSLocalizedString("UI_Menu_Title", comment: "")
        let uiNavi = MyNavigationController.init(rootViewController: UIctl)
        uiNavi.tabBarItem = UITabBarItem.init(title: NSLocalizedString("UI_Menu_Title", comment: ""),
                                              image: UIImage.init(named: "activeIcon.png"), tag: TabbarItemTag.UI.rawValue)
        
        let thirdCtl = ThirdMenuViewController();
        thirdCtl.title = NSLocalizedString("Third_Menu_Title", comment: "")
        let thirdNavi = MyNavigationController.init(rootViewController: thirdCtl);
        thirdNavi.tabBarItem = UITabBarItem.init(title: NSLocalizedString("Third_Menu_Title", comment: ""),
                                                 image: UIImage.init(named: "activeIcon.png"), tag: TabbarItemTag.third.rawValue)

        let funcCtl = FuncMenuViewController();
        funcCtl.title = NSLocalizedString("Funct_Menu_Title", comment: "")
        let funcNavi = MyNavigationController.init(rootViewController: funcCtl);
        funcNavi.tabBarItem = UITabBarItem.init(title: NSLocalizedString("Funct_Menu_Title", comment: ""),
                                                image: UIImage.init(named: "activeIcon.png"), tag: TabbarItemTag.function.rawValue)
        
        let toolCtl = MyToolsMenuViewController();
        toolCtl.title = NSLocalizedString("Tools_Menu_Title", comment: "")
        let toolNavi = MyNavigationController.init(rootViewController: toolCtl);
        toolNavi.tabBarItem = UITabBarItem.init(title: NSLocalizedString("Tools_Menu_Title", comment: ""),
                                                image: UIImage.init(named: "activeIcon.png"), tag: TabbarItemTag.tools.rawValue)
        
        self.viewControllers = [uiNavi, thirdNavi, funcNavi, toolNavi];
//        self.viewControllers = [UIctl, thirdCtl, funcCtl, toolCtl];
        
    }
    
    //MARK: tab bar controller delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("\(type(of: self)) \(#function) line: \(#line)")
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("\(type(of: self)) \(#function) line: \(#line) \(viewController.tabBarItem.tag)")
    }

    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        /*
         动画进度需要控制的时候使用，例如：根据手势的变化而变化
         let interactiveTransition = UIPercentDrivenInteractiveTransition.init();
         [interactiveTransition updateInteractiveTransition:progress];
         [interactiveTransition finishInteractiveTransition];
         [interactiveTransition cancelInteractiveTransition];
         */
        
        return nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC.tabBarItem.tag == toVC.tabBarItem.tag {
            return nil
        }
        
        let transAnima = TabbarTransitionAnimation.init()
        transAnima.toLeft = fromVC.tabBarItem.tag < toVC.tabBarItem.tag
        
        return transAnima
        


    }
}




