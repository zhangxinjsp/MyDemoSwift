//
//  MyCentralViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/25.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MyCentralViewController: MyBaseViewController, BluetoothCentralDelegate {
    
    let central = CentralManager.init()
    let textView = UITextView.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        central.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textView]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["textView" : textView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textView]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["textView" : textView]))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func showInfo(_ text: String) {
        textView.text = textView.text + "\n" + text
    }
}
