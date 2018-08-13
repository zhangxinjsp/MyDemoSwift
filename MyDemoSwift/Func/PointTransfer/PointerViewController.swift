//
//  PointTransferViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/8/3.
//  Copyright © 2018年 张鑫. All rights reserved.
//

//  https://docs.developer.apple.com/documentation/swift/swift_standard_library/manual_memory_management

import UIKit

class PointerViewController: MyBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        unsafePointer()
        
        
        
        rawPointerInit()
        
        cfDictionaryCreate()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /********  Calling Functions With Pointer Parameters  **********/
    
    func PassConstantPointerParameter() {
        
        func takesAPointer(_ p: UnsafePointer<Float>) {
            // ...
        }
        
        var x: Float = 0.0
        takesAPointer(&x)
        takesAPointer([1.0, 2.0, 3.0])
        
        
        func takesARawPointer(_ p: UnsafeRawPointer?)  {
            // ...
        }
        
        var y: Int = 0
        takesARawPointer(&x)
        takesARawPointer(&y)
        takesARawPointer([1.0, 2.0, 3.0] as [Float])
        let intArray = [1, 2, 3]
        takesARawPointer(intArray)
        takesARawPointer("How are you today?")
        
    }
    
    func PassMutablePointerParameter() {
        
        func takesAMutablePointer(_ p: UnsafeMutablePointer<Float>) {
            // ...
        }
        
        var x: Float = 0.0
        var a: [Float] = [1.0, 2.0, 3.0]
        takesAMutablePointer(&x)
        takesAMutablePointer(&a)
        
        func takesAMutableRawPointer(_ p: UnsafeMutableRawPointer?)  {
            // ...
        }
        
        var y: Int = 0
        var b: [Int] = [1, 2, 3]
        takesAMutableRawPointer(&x)
        takesAMutableRawPointer(&y)
        takesAMutableRawPointer(&a)
        takesAMutableRawPointer(&b)
        
        
    }
    
    /********  UnsafePointer  **********/
    
    func unsafePointer() {
        
        let int_point = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        int_point.initialize(to: 5)
        
        let ptr: UnsafePointer<Int> = UnsafePointer<Int>.init(int_point)!
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(ptr.pointee)")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(ptr[0])")
        
        func fetchEightBytes() -> UnsafePointer<UInt8> {
            let point = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
            point.initialize(to: 5)
            return UnsafePointer<UInt8>.init(point)!
        }

        let uint8Pointer: UnsafePointer<UInt8> = fetchEightBytes()
        
        let length = uint8Pointer.withMemoryRebound(to: Int8.self, capacity: 8) {
            return strlen($0)
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(length)")
        
        let uint64Pointer = UnsafeRawPointer(uint8Pointer).bindMemory(to: UInt64.self, capacity: 1)
        
        var fullInteger = uint64Pointer.pointee          // OK
        var firstByte = uint8Pointer.pointee             // undefined
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(fullInteger),, \(firstByte)")
        
        let rawPointer = UnsafeRawPointer(uint64Pointer)
        fullInteger = rawPointer.load(as: UInt64.self)   // OK
        firstByte = rawPointer.load(as: UInt8.self)      // OK
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(fullInteger),, \(firstByte)")
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
    
    func pointerTransferWithUnsafePoint () {
        
        var key1 = kSecImportExportPassphrase
        
        let keyPoint = withUnsafeMutablePointer(to: &key1) { (a:UnsafeMutablePointer<CFString>?) -> UnsafeMutablePointer<UnsafeRawPointer?> in
            let m = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            m.pointee = UnsafeRawPointer(a!)!
            return m
        }
    
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: keyPoint))  \(keyPoint)")
        
    }
    
    func pointerTransferUnmanagedToOpaque() {
        let value = Unmanaged.passRetained("123456" as NSString).autorelease().toOpaque()
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: value)) \(value)")
        
    }
    
    func pointerTransferUnsafeBitCast() {
        
        let str = UnsafeMutablePointer<String>.allocate(capacity: 1)
        str.initialize(to: "zhangxin")

        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: str.pointee)) \(str.pointee)")
//        var str = "aasdfasdf"
        
        let raw = UnsafeRawPointer(str)
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(raw.load(as: String.self))")
        
        let rawValue = unsafeBitCast(raw, to: String.self)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: rawValue)) \(rawValue)")
        
//    let dict = unsafeBitCast(CFArrayGetValueAtIndex(items, 0), to: CFDictionary.self)
//
//    let identity = unsafeBitCast(CFDictionaryGetValue(dict, identityKey), to: SecIdentity.self)
        
    }
    
    func rawPointerInit() {
        
        let strPoint = UnsafeMutablePointer<String>.allocate(capacity: 1)
        strPoint.initialize(to: "zhangxin")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: strPoint.pointee)) \(strPoint.pointee)")
        
        let raw = UnsafeRawPointer(strPoint)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(raw.load(as: String.self))")
        
        
        var str = "aasdfasdf"
        let raw1 = UnsafeMutableRawPointer(&str)
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(raw1.load(as: String.self))")
        
        
        
        
    }
    
    /********* CFDictionary 参数传递 ********/
    func cfDictionaryCreate() {
        
        let key1 = UnsafeMutablePointer<NSString>.allocate(capacity: 1)
        key1.initialize(to: "key1" as NSString)
        let value1 = UnsafeMutablePointer<NSString>.allocate(capacity: 1)
        value1.initialize(to: "value1" as NSString)

        var keys:[UnsafeRawPointer?] = [UnsafeRawPointer(key1)]
        var values:[UnsafeRawPointer?] = [UnsafeRawPointer(value1)]

        let dict:CFDictionary = CFDictionaryCreate(kCFAllocatorDefault, &keys, &values, keys.count, nil, nil)

        print("\(CFDictionaryGetCount(dict))")

        print("\(CFDictionaryGetValue(dict, UnsafeRawPointer(key1)).load(as: NSString.self))")
        
//        CFDictionaryCreate(<#T##allocator: CFAllocator!##CFAllocator!#>, <#T##keys: UnsafeMutablePointer<UnsafeRawPointer?>!##UnsafeMutablePointer<UnsafeRawPointer?>!#>, <#T##values: UnsafeMutablePointer<UnsafeRawPointer?>!##UnsafeMutablePointer<UnsafeRawPointer?>!#>, <#T##numValues: CFIndex##CFIndex#>, <#T##keyCallBacks: UnsafePointer<CFDictionaryKeyCallBacks>!##UnsafePointer<CFDictionaryKeyCallBacks>!#>, <#T##valueCallBacks: UnsafePointer<CFDictionaryValueCallBacks>!##UnsafePointer<CFDictionaryValueCallBacks>!#>)
//        CFDictionarySetValue(<#T##theDict: CFMutableDictionary!##CFMutableDictionary!#>, <#T##key: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##value: UnsafeRawPointer!##UnsafeRawPointer!#>)
        
        /*  success  */
        let key = Unmanaged.passRetained(kSecImportExportPassphrase as NSString).autorelease().toOpaque()
        let value = Unmanaged.passRetained("123456" as NSString).autorelease().toOpaque()

//        let key1 = Unmanaged.passRetained("key" as NSString).autorelease().toOpaque()
//        let value1 = Unmanaged.passsRetained("123456" as NSString).autorelease().toOpaque()

        let options:CFDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, nil, nil)
        CFDictionarySetValue(options as! CFMutableDictionary, key, value)
        CFDictionarySetValue(options as! CFMutableDictionary, key1, value1)

        print("\(CFDictionaryGetCount(options))")
        print("\(CFDictionaryGetValue(options, key1).load(as: String.self))")
        print("\(unsafeBitCast(CFDictionaryGetValue(options, key), to: NSString.self) )")
        
        
    }
    
    
    
    
    
    
    
}
