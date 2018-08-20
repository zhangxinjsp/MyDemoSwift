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

    let socketPort:UInt16 = 8888
    
    var socket:CFSocket? = nil
    var socketThread:Thread? = nil
    
    var textView:UITextView = UITextView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        createSubcontrol()
        
        socketThread = Thread.init(target: self, selector: #selector(runLoopInThread), object: nil)
        socketThread?.name = "socketService"
        socketThread?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSubcontrol() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.red
        textView.text = "start"
        textView.isEditable = false
        self.view.addSubview(textView)
        
        let viewsDict:Dictionary = ["textView" : textView]
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textView(>=0)]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[textView(300)]-(>=0)-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
    }
    
    public func updateText(text:String)  {
        DispatchQueue.main.async {
            self.textView.text = self.textView.text + "\n" + text
        }
        
    }

    // 开辟一个线程线程函数中
    @objc func runLoopInThread() {
        if !self.initSocketService() {
            exit(1);
        }
        updateText(text: "run in thread \(String(describing: Thread.current.name))")
        let cfRunLoop:CFRunLoop = CFRunLoopGetCurrent();
        let source:CFRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,socket, 0);
        CFRunLoopAddSource(cfRunLoop, source, CFRunLoopMode.commonModes);
        
        //        CFRelease(source);
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
        updateText(text: "socket create success")
        var optval:Int = 1;
        setsockopt(CFSocketGetNative(socket),
                   SOL_SOCKET,
                   SO_REUSEADDR, // 允许重用本地地址和端口
                   &optval,
                   socklen_t(MemoryLayout.size(ofValue: optval)))
        
        var ipv4 = sockaddr_in()
        ipv4.sin_len = __uint8_t(MemoryLayout.size(ofValue: ipv4))
        ipv4.sin_family = sa_family_t(AF_INET)
        ipv4.sin_port = socketPort.bigEndian
        ipv4.sin_addr.s_addr = INADDR_ANY.bigEndian //inet_addr((address as NSString).utf8String)  // 把字符串的地址转换为机器可识别的网络地址
        
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
        
        updateText(text: "socket set address success")
        
        return true;
    }
    // socket回调函数，同客户端
    
    
    
    let socketCallback:CFSocketCallBack = {(socket:CFSocket?, callbackType:CFSocketCallBackType, address:CFData?, data:UnsafeRawPointer?, info:UnsafeMutableRawPointer?) in
        
//        info!.load(as: MySocketServiceViewController.self).updateText(text: "connected success")
        let readStream:CFReadStreamClientCallBack = {(stream:CFReadStream?, eventType:CFStreamEventType, info:UnsafeMutableRawPointer?) in
            var buff:[UInt8] = []
            CFReadStreamRead(stream, &buff, 255);
            print("received: \(buff)");
        }
        
        let writeStream:CFWriteStreamClientCallBack = {(stream:CFWriteStream?, eventType:CFStreamEventType, info:UnsafeMutableRawPointer?) in
            
            let data = [UInt8]("aaa".data(using: String.Encoding.utf8)!)
            
            if (stream != nil) {
                CFWriteStreamWrite(stream, data, 6)
            } else {
                print("Cannot send data!")
            }
        }
        
        if (CFSocketCallBackType.acceptCallBack == callbackType) {
            // 本地套接字句柄
            let nativeSocketHandle:CFSocketNativeHandle = (data?.load(as: CFSocketNativeHandle.self))!
            var name:sockaddr = sockaddr()
            var nameLen:socklen_t = socklen_t(MemoryLayout.size(ofValue: name))
            
            if (0 != getpeername(nativeSocketHandle, &name, &nameLen)) {
                print("error")
                exit(1);
            }
            print("connected to \(name)")
            
            // 创建一个可读写的socket连接
            var iStream:Unmanaged<CFReadStream>? = nil
            var oStream:Unmanaged<CFWriteStream>? = nil
            CFStreamCreatePairWithSocket(kCFAllocatorDefault,nativeSocketHandle, &iStream, &oStream)
            
            if (iStream != nil && oStream != nil) {
                var streamContext:CFStreamClientContext = CFStreamClientContext()//{0, NULL, NULL, NULL}
                streamContext.version = 0
                streamContext.info = info
                
                let readStatus = CFReadStreamSetClient(iStream?.takeUnretainedValue(),
                                                   CFStreamEventType.hasBytesAvailable.rawValue,
                                                   readStream, // 回调函数，当有可读的数据时调用
                                                   &streamContext)
                
                
                if !readStatus {
                    exit(1);
                }
            
                let writeStatus = CFWriteStreamSetClient(oStream?.takeUnretainedValue(),
                                                         CFStreamEventType.canAcceptBytes.rawValue,
                                                         writeStream,
                                                         &streamContext)
                
                
                if (!writeStatus){
                    exit(1);
                }
                CFReadStreamScheduleWithRunLoop(iStream?.takeUnretainedValue(), CFRunLoopGetCurrent(), CFRunLoopMode.commonModes);
                CFWriteStreamScheduleWithRunLoop(oStream?.takeUnretainedValue(), CFRunLoopGetCurrent(), CFRunLoopMode.commonModes);
                CFReadStreamOpen(iStream?.takeUnretainedValue());
                CFWriteStreamOpen(oStream?.takeUnretainedValue());
            } else {
                close(nativeSocketHandle);
            }
        }
    }
        
        
        
        
        
        

}
