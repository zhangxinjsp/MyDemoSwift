//
//  PointTransferViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/8/3.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class PointerViewController: MyBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pointerInit()
        
        pointerTransferUseFunc()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pointerInit() {
        
        let int_point = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        
        int_point.initialize(to: 5)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(int_point.pointee)")//5
        
        int_point.pointee = 10;
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(int_point.pointee)")//10
        
        int_point.deinitialize(count: 1)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(int_point.pointee)")//10
        
        int_point.deallocate()
    }
    
    func pointerTransferUseFunc() {
        let int_point = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        
        int_point.initialize(to: 5)
        
        var a = int_point.pointee
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(a)")//5
        
        func point (poi:UnsafeMutablePointer<Int>) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(poi.pointee)")//5
            poi.pointee = 10
        }
        point(poi: &a)
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(a)")//10
    }
    
    func qqqqqq() {
        
//        UnsafePointer<UInt8>    ==  [UInt8]("string".utf8)
//        UnsafeMutablePointer<UInt8>  ==  [UInt8](repeating: 0, count: Int(blockSize))
        
    }
    
    func withUnsafePoint () {
        
    
    
    
        var key1 = kSecImportExportPassphrase
        var value1 = "123456"

        let keyPoint = withUnsafeMutablePointer(to: &key1) { (a:UnsafeMutablePointer<CFString>?) -> UnsafeMutablePointer<UnsafeRawPointer?> in
            let m = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            m.pointee = UnsafeRawPointer(a!)!
            return m
        }
        let valuePoint = withUnsafeMutablePointer(to: &value1) { (a:UnsafeMutablePointer<String>?) -> UnsafeMutablePointer<UnsafeRawPointer?> in
            let m = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            m.pointee = UnsafeRawPointer(a!)!
            return m
        }
        let options1:CFDictionary = CFDictionaryCreate(kCFAllocatorDefault,
                                                      keyPoint,
                                                      valuePoint,
                                                      2, nil, nil)
//        CFDictionaryCreate(<#T##allocator: CFAllocator!##CFAllocator!#>, <#T##keys: UnsafeMutablePointer<UnsafeRawPointer?>!##UnsafeMutablePointer<UnsafeRawPointer?>!#>, <#T##values: UnsafeMutablePointer<UnsafeRawPointer?>!##UnsafeMutablePointer<UnsafeRawPointer?>!#>, <#T##numValues: CFIndex##CFIndex#>, <#T##keyCallBacks: UnsafePointer<CFDictionaryKeyCallBacks>!##UnsafePointer<CFDictionaryKeyCallBacks>!#>, <#T##valueCallBacks: UnsafePointer<CFDictionaryValueCallBacks>!##UnsafePointer<CFDictionaryValueCallBacks>!#>)
    
        print("\(options1)")
//    let dict = unsafeBitCast(CFArrayGetValueAtIndex(items, 0), to: CFDictionary.self)
//    
//    let identityKey = Unmanaged.passRetained(kSecImportItemIdentity as string).autorelease().toOpaque()
//    
//    let identity = unsafeBitCast(CFDictionaryGetValue(dict, identityKey), to: SecIdentity.self)

        
        
    }
    
    func unmanagedToOpaque() {
        let value = Unmanaged.passRetained("123456" as NSString).autorelease().toOpaque()
        
        
        print("\(type(of: value)) ")
        
    }
}
