//
//  MySocketClientViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/8/7.
//  Copyright © 2018年 张鑫. All rights reserved.
//

/*
 https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/NetworkingTopics/Articles/UsingSocketsandSocketStreams.html#//apple_ref/doc/uid/CH73-SW1
 https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/SocketsAndStreams/SocketsAndStreams.html#//apple_ref/doc/uid/TP40010220-CH203-CJBEFGHG
 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Streams/Articles/NetworkStreams.html#//apple_ref/doc/uid/20002277-BCIDFCDI
 */

import UIKit

class MySocketClientViewController: MyBaseViewController, StreamDelegate {
    
    let socketUrl = "192:168:2:8"//ABCD:EF01:2345:6789:ABCD:EF01:2345:6789
    let socketPort:UInt16 = 8888
    var inputStream:InputStream?
    var outputStream:OutputStream?
    
    var socket:CFSocket?
    var addressData:CFData?
    var socketThread:Thread?
    var sendThread:Thread?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        streamSocket()
        
        createSocket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSubcontrol() {
        let label:UILabel = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.text = "aaaaa"
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let viewsDict:Dictionary = ["label" : label]
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label(>=0)]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[label(100)]-(>=0)-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
    }

    

    // MARK: - stream socket
    func streamSocket() {
        
        var readStream:Unmanaged<CFReadStream>? = nil
        var writeStream:Unmanaged<CFWriteStream>? = nil
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, socketUrl as CFString, UInt32(socketPort), &readStream, &writeStream)
        
        print("\(type(of: readStream)) \(String(describing: readStream))")
        print("\(type(of: writeStream)) \(String(describing: writeStream))")

        inputStream = readStream?.takeUnretainedValue()
        inputStream?.delegate = self
        inputStream?.setProperty(StreamSocketSecurityLevel.ssLv2, forKey: Stream.PropertyKey.socketSecurityLevelKey)
        inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        inputStream?.open()
        
        outputStream = writeStream?.takeUnretainedValue()
        outputStream?.delegate = self
        outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outputStream?.open()
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("\(String(describing: eventCode) )")
        switch eventCode {
        case .openCompleted:
            
            break
            
        case .hasBytesAvailable:
            
            if aStream == inputStream {
                var buffer:[UInt8] = [UInt8](repeating: 0, count: 100)
                inputStream?.read(&buffer, maxLength: 100)
            }
            break
            
        case .hasSpaceAvailable:
            if aStream == outputStream {
                let name:String = "xiawtwe"
                let data = [UInt8](name.utf8)
                outputStream?.write(data, maxLength: name.count)
            }
            break
            
        case .errorOccurred:
            
            break
            
        case .endEncountered:
            
            break
            
        default:
            print("\(eventCode)")
        }
    }
    
    // MARK: - socket
    func socketAddressData(address:String, port:UInt16) -> CFData? {
        
        if !address.contains(":") {
            return nil
        }
        
        let isIPV4 = true
        
        if isIPV4 {
            
//            let strIp:[String] = address.components(separatedBy: ":")
//            let int8Ip:[Int8] = [Int8(strIp[0])!, Int8(strIp[1])!, Int8(strIp[2])!, Int8(strIp[3])!]
            
            var ipv4 = sockaddr_in()
            ipv4.sin_len = __uint8_t(MemoryLayout.size(ofValue: ipv4))
            ipv4.sin_family = sa_family_t(AF_INET)
            ipv4.sin_port = in_port_t(port)
            ipv4.sin_addr.s_addr = inet_addr((address as NSString).utf8String)  // 把字符串的地址转换为机器可识别的网络地址

            print("\(ipv4)")
            
            var ipv4Bytes:[UInt8] = [UInt8](repeating: 0, count: MemoryLayout.size(ofValue: ipv4))
            
            let ipv4Data =  Data.init(bytes: &ipv4, count: MemoryLayout.size(ofValue: ipv4))
            ipv4Data.copyBytes(to: &ipv4Bytes, count: MemoryLayout.size(ofValue: ipv4))
            let ipv4CFData = CFDataCreate(kCFAllocatorDefault, ipv4Bytes, MemoryLayout.size(ofValue: ipv4))
            
            return ipv4CFData
            
        } else {
            
            var ipv6 = sockaddr_in6()   // IPV6
            ipv6.sin6_len = __uint8_t(MemoryLayout.size(ofValue: ipv6))
            ipv6.sin6_family = sa_family_t(AF_INET6)
            ipv6.sin6_port = port
            
            inet_pton(AF_INET6, (address as NSString).utf8String, &ipv6.sin6_addr)
            
            print("\(ipv6)")
            
            var ipv6Bytes:[UInt8] = [UInt8](repeating: 0, count: MemoryLayout.size(ofValue: ipv6))
            
            let ipv6Data =  Data.init(bytes: &ipv6, count: MemoryLayout.size(ofValue: ipv6))
            ipv6Data.copyBytes(to: &ipv6Bytes, count: MemoryLayout.size(ofValue: ipv6))
            let ipv6CFData = CFDataCreate(kCFAllocatorDefault, ipv6Bytes, MemoryLayout.size(ofValue: ipv6))
            
            return ipv6CFData
        }
    }
    
    func createSocket() {
        
        addressData = self.socketAddressData(address: socketUrl, port: socketPort)
        
        let isIPv6 = false
        
        var weakSelf = self
        
        var sockContext = CFSocketContext.init(version: 0, info: &weakSelf, retain: nil, release: nil, copyDescription: nil)
        
        let callbackTypes = UInt8(CFSocketCallBackType.connectCallBack.rawValue) | UInt8(CFSocketCallBackType.readCallBack.rawValue) | UInt8(CFSocketCallBackType.writeCallBack.rawValue) | UInt8(CFSocketCallBackType.dataCallBack.rawValue) | UInt8(CFSocketCallBackType.acceptCallBack.rawValue)

        socket = CFSocketCreate(kCFAllocatorDefault, isIPv6 ? PF_INET6 : PF_INET, SOCK_STREAM, IPPROTO_TCP, CFOptionFlags(callbackTypes), socketCallback, &sockContext)
        
        var sockopt:CFOptionFlags = CFSocketGetSocketFlags(socket)
        sockopt |= kCFSocketCloseOnInvalidate | kCFSocketAutomaticallyReenableReadCallBack
        CFSocketSetSocketFlags(socket, sockopt)
        
        if (socket != nil) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) create socket success")
            socketThread = Thread.init(target: self, selector: #selector(socketThreadStart), object: nil)
            socketThread?.name = "startSocket"
            socketThread?.start()
            
            sendThread = Thread.init(target: self, selector: #selector(sendMessage), object: nil)
            sendThread?.name = "sendMessage"
            sendThread?.start()
        } else {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) create socket failed")
        }
        
    }
    
    func stopScoket() {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) stop socket")
        
        if (socket != nil) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) invalidate socket")
            
            if (CFSocketIsValid(socket)) {
                CFSocketInvalidate(socket)
            }
            close(CFSocketGetNative(socket))
//            CFRelease(socket)
            socket = nil
        }
        
        if (!(socketThread?.isCancelled)!) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) cancel socket thread ")
            socketThread?.cancel()
            socketThread = nil
        }
        
        if (!(sendThread?.isCancelled)!) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) cancel send thread ")
            sendThread?.cancel()
            sendThread = nil
        }
    }

    let socketCallback : @convention(c) (CFSocket?, CFSocketCallBackType, CFData?, UnsafeRawPointer?, UnsafeMutableRawPointer?) -> Swift.Void = {(socket:CFSocket?, callbackType:CFSocketCallBackType, address:CFData?, data:UnsafeRawPointer?, info:UnsafeMutableRawPointer?) in
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(callbackType)")
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) info: <\(String(describing: info?.load(as: String.self)))>")
        switch (callbackType) {
        case .readCallBack:
            
            break
            
        case .acceptCallBack:
            
            break
            
        case .connectCallBack:
            if (data != nil) {
                // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) 连接失败")
            } else {
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) 连接成功")
            }
            DispatchQueue.main.async {
                //info 指向的对象调用相应的方法
            }
            break
            
        case .dataCallBack:
            
            let receiveData:Data =   (data?.load(as: Data.self))!
            DispatchQueue.main.async {
                //info 指向的对象调用相应的方法
            }
            break
            
        case .writeCallBack:
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) writeCallBack")
            break
            
        default:
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) default")
            break
        }
    }

    @objc func socketThreadStart() {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: Thread.current.name))")
        
        let status:CFSocketError = CFSocketConnectToAddress(socket, addressData, 3)
        
        if (status == .success) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) connect to address success")
            let cRunRef:CFRunLoop = CFRunLoopGetCurrent()
            let sourceRef:CFRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
            CFRunLoopAddSource(cRunRef, sourceRef, CFRunLoopMode.defaultMode);
            CFRunLoopRun();
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) run loop stoped");
            
            CFRunLoopRemoveSource(cRunRef, sourceRef, CFRunLoopMode.commonModes);
            //    cRunRef = nil;
            
            if (CFRunLoopSourceIsValid(sourceRef)) {
                CFRunLoopSourceInvalidate(sourceRef);
            }
            //    CFRelease(sourceRef);
            //    sourceRef = nil;
            
        } else {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) connect to address failed");
            self.stopScoket()
        }
    }
    
    @objc func sendMessage() {
    
        while (!(sendThread?.isCancelled)!) {
//            if (socket != nil) {
//                let data = [UInt8]("aaa".data(using: String.Encoding.utf8)!)
//                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(data)");
//
//                let sendData:CFData = CFDataCreate(kCFAllocatorDefault, data, data.count);
//                let error:CFSocketError = CFSocketSendData(socket, addressData, sendData, 10);
//                if (error == .success) {
//                    print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) success");
//                } else {
//                    print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) failed");
//                    DispatchQueue.main.async {
//
//                    }
//                }
//            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
