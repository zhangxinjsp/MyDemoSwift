//
//  MySocketServiceViewController.swift
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

class MySocketServiceViewController: MyBaseViewController {

    var socket:CFSocket? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 开辟一个线程线程函数中
    func runLoopInThread() {
        if !self.initSocketService() {
            exit(1);
        }
        CFRunLoopRun();    // 运行当前线程的CFRunLoop对象
    }
    
    func initSocketService() -> Bool{
    
        socket = CFSocketCreate(kCFAllocatorDefault,
                                PF_INET,
                                SOCK_STREAM,
                                IPPROTO_TCP,
                                CFSocketCallBackType.acceptCallBack.rawValue,
                                socketCallback,
                                nil)
        if nil == socket {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) Cannot create socket!")
            return false
        }
//
        var optval:Int = 1;
        setsockopt(CFSocketGetNative(socket),
                   SOL_SOCKET,
                   SO_REUSEADDR, // 允许重用本地地址和端口
                   &optval,
                   socklen_t(MemoryLayout.size(ofValue: optval)))
        
        var ipv4 = sockaddr_in()
        ipv4.sin_len = __uint8_t(MemoryLayout.size(ofValue: ipv4))
        ipv4.sin_family = sa_family_t(AF_INET)
        ipv4.sin_port = in_port_t(8888)
        ipv4.sin_addr.s_addr = INADDR_ANY //inet_addr((address as NSString).utf8String)  // 把字符串的地址转换为机器可识别的网络地址
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(ipv4)")
        
        var ipv4Bytes:[UInt8] = [UInt8](repeating: 0, count: MemoryLayout.size(ofValue: ipv4))
        
        let ipv4Data =  Data.init(bytes: &ipv4, count: MemoryLayout.size(ofValue: ipv4))
        ipv4Data.copyBytes(to: &ipv4Bytes, count: MemoryLayout.size(ofValue: ipv4))
        let ipv4CFData = CFDataCreate(kCFAllocatorDefault, ipv4Bytes, MemoryLayout.size(ofValue: ipv4))

        if CFSocketError.success != CFSocketSetAddress(socket, ipv4CFData) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) Bind to address failed!")
            if socket != nil {
//                CFRelease(socket);
//                socket = NULL;
                return false;
            }
        }

        let cfRunLoop:CFRunLoop = CFRunLoopGetCurrent();
        let source:CFRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,socket, 0);
        CFRunLoopAddSource(cfRunLoop, source, CFRunLoopMode.commonModes);
//        CFRelease(source);
        
        return true;
    }
    // socket回调函数，同客户端
    let socketCallback : @convention(c) (CFSocket?, CFSocketCallBackType, CFData?, UnsafeRawPointer?, UnsafeMutableRawPointer?) -> Swift.Void = {(socket:CFSocket?, callbackType:CFSocketCallBackType, address:CFData?, data:UnsafeRawPointer?, info:UnsafeMutableRawPointer?) in
        
//    if (kCFSocketAcceptCallBack == type) {
//    // 本地套接字句柄
//    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
//    uint8_t name[SOCK_MAXADDRLEN];
//    socklen_t nameLen = sizeof(name);
//    if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name,&nameLen)) {
//    NSLog(@"error");
//    exit(1);
//    }
//    NSLog(@"%s connected.", inet_ntoa( ((struct sockaddr_in*)name)->sin_addr ));
//    CFReadStreamRef iStream;
//    CFWriteStreamRef oStream;
//    // 创建一个可读写的socket连接
//    CFStreamCreatePairWithSocket(kCFAllocatorDefault,nativeSocketHandle, &iStream, &oStream);
//    if (iStream && oStream) {
//    CFStreamClientContext streamContext = {0, NULL, NULL, NULL};
//    if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,
//    readStream, // 回调函数，当有可读的数据时调用
//    &streamContext)){
//    exit(1);
//    }
//
//    if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream, &streamContext)){
//    exit(1);
//    }
//    CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//    CFWriteStreamScheduleWithRunLoop(oStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//    CFReadStreamOpen(iStream);
//    CFWriteStreamOpen(oStream);
//    } else {
//    close(nativeSocketHandle);
//    }
//    }
    }

}
