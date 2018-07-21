//
//  MyRunTimeViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/19.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MyRunTimeViewController: MyBaseViewController {
    
    var people:MyRunTimeModel = MyRunTimeModel()
//    var people:MyOCParmModel = MyOCParmModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modeToDict()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     /******************** mode dict transfer start  ***********************/
    
    func modeAndDictTranfer() {
        let dict:[String : Any] = ["name" : "jack",
                                   "age": 35,
                                   "sex": "man",
                                   "height": 182.2,
                                   "weight": 95,
                                   "unddefine": "95",
                                   ]
        
//        let dict:[String : Any] = ["name" : NSString.init(string: "jack") ,
//                                   "age": NSNumber.init(value: 35),
//                                   "sex": NSString.init(string: "man"),
//                                   "height": NSNumber.init(value: 182.2),
//                                   "weight": NSNumber.init(value: 95),
//                                   "unddefine": NSString.init(string: "95"),
//                                   ]

//        let dict:[String : AnyObject] = ["name" : "jack" as AnyObject,
//                                   "age": 35 as AnyObject,
//                                   "sex": "man" as AnyObject,
//                                   "height": 182.2 as AnyObject,
//                                   "weight": 95 as AnyObject,
//                                   "unddefine": "95" as AnyObject,
//                                   ]
        
        self.dictionaryToModelMethod1(dict: dict)
//        self.dictionaryToModelMethod2(dict: dict)
//        self.dictionaryToModelMethod3(dict: dict)
        
        self.modeToDict()
    }
    
    /*
     注意事项
     1. setValuesForKeys  注意点
        a).此方法，需要将参数天假objc的入口，在参数前添加@objc
        b).dict 里面的值类型 要与 对象的类型一致 否则 object_getIvar获取值的时候会bad address
     2. object_setIvar
        a). mode 参数为 swoft 类型参数（String，Int）时 设值之后，会是乱值 people, name: `, age:-5764607523034234317, sex:\220\200r, height:5.99904e-31, weight:2.13418e-42
        b). mode 参数为 OC 类型参数（NSStrig，NSInt）时 设值之后，取值是会bad address,
            当dictionary 的类型与mode 一致的时候就可以
     3.object_getIvar
        a).对应的属性的类型为基本数据类型或者是swift中的对象类型(例如String)时就会崩溃。只有是OC中的对象时才能正常获取
        b).要使用swift的时候可以使用。let value = people.value(forKey: String(cString: name!))
     4.ivar_getTypeEncoding
        a).在swift 是无效的
     */
    
    func dictionaryToModelMethod1 (dict:Dictionary<String, Any>) {
        
        people.setValuesForKeys(dict)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(people.description)")
    }
    
    func dictionaryToModelMethod2 (dict:Dictionary<String, Any>) {
        var count:UInt32 = 0
        let varList = class_copyIvarList(type(of: people), &count)
        
        for i in 0..<count {
            let ivar = varList?[Int(i)]
            
            let typecod = ivar_getTypeEncoding(ivar!)
            print("\(i) ---- \(NSString.localizedStringWithFormat("%s", typecod!))")
            
            let name = ivar_getName(ivar!)
            print("\(i) ---- \(String(describing: String(cString: name!)))")
            
            let offset = ivar_getOffset(ivar!)
            print("\(i) ---- \(offset)")
            
            let value = dict[String(cString: name!)]
            object_setIvar(people, ivar!, value)
            print("\(i) ---- \(String(describing: value))")
        }

        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(people.description)")
        
    }
    
    func dictionaryToModelMethod3 (dict:Dictionary<String, Any>) {

        
        for key in dict.keys {
            
            let ivar = class_getInstanceVariable(type(of: people), key)
            let value = dict[key]
            if ivar != nil {
                object_setIvar(people, ivar!, value)
            }
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: value))  \(key) : \(String(describing: value))")
            
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(people.description)")
        
    }

    func modeToDict() {
        
        var resultDict:Dictionary<String, Any> = [:]
        
        var count:UInt32 = 0
        let varList = class_copyIvarList(type(of: people), &count)
        
        for i in 0..<count {
            let ivar = varList?[Int(i)]
            
            let typecod = ivar_getTypeEncoding(ivar!)//
            let name = ivar_getName(ivar!)
            let offset = ivar_getOffset(ivar!)
            
//            let value = object_getIvar(people, ivar!)
            let value = people.value(forKey: String(cString: name!))
            
            print("\(i) ---- \(String(cString: typecod!))  \(String(describing: String(cString: name!))) \(offset) \(String(describing: value)))")
            
            resultDict.updateValue(value!, forKey: String(cString: name!))
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(resultDict)")
    }
    
    /******************** mode dict transfer end  ***********************/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}
