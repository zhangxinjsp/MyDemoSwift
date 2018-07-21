//
//  MyRunTimeModel.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/19.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MyRunTimeModel: NSObject {
    
    @objc var name:String = "1"
    @objc var age:Int = 2
    @objc var sex:String = "man"
    @objc var height:Float = 182.2
    @objc var weight:Float = 95.5
    
    
    func functionA() {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) this is func A this is func A")
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(key):\(String(describing: value))")
    }
    
    override var description: String {
        return "this people, name: \(name), age:\(age), sex:\(sex), height:\(height), weight:\(weight)"
    }
}

class MyOCParmModel: NSObject {
    @objc var name:NSString = "1"
    @objc var age:NSNumber = 2
    @objc var sex:NSString = "man"
    @objc var height:NSNumber = 182.2
    @objc var weight:NSNumber = 95.5
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(key):\(String(describing: value))")
    }
    
    override var description: String {
        return "this people, name: \(name), age:\(age), sex:\(sex), height:\(height), weight:\(weight)"
    }
}
