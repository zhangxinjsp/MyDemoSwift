//
//  TabBarController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2017/3/24.
//  Copyright © 2017年 张鑫. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewCtl1 = ViewController();
        viewCtl1.title = "aaaa";
        let navi1 = MyNavigationController.init(rootViewController: viewCtl1)
        navi1.tabBarItem = UITabBarItem.init(title: "1111", image: UIImage.init(named: "activeIcon.png"), tag: 0)
        
        
        
        let viewCtl2 = ViewController();
        viewCtl2.title = "bbbbb"
        let navi2 = MyNavigationController.init(rootViewController: viewCtl2);
        navi2.tabBarItem = UITabBarItem.init(title: "2222", image: UIImage.init(named: "activeIcon.png"), tag: 1)
        
        self.viewControllers = [navi1, navi2];
        
        
        
    }
}
