//
//  ViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2017/3/24.
//  Copyright © 2017年 张鑫. All rights reserved.
//

import UIKit

class ViewController: MyBaseViewController {
    
    let awake = 1;
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "asdfasdf";
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        
        label.text = "test";
        
        self.view .addSubview(label)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

