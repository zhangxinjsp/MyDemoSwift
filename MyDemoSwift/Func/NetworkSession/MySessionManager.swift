//
//  MySessionConnection.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit
import Foundation


//let url:String = "https://pkicatest.mychery.com:448/cherym31t/command";
let url:String = "https://sh.syan.com.cn:7756/cherym31t/command";//信任站点
//let url:String = "https://sh.syan.com.cn:7758/cherym31t/command";//不信任站点
//let url:String = "https://203.93.252.29:18088/cherym31t/command"
//let url:String = "https://203.93.252.40:8088/cherym31t/command";

class MySessionManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    static let shared:MySessionManager = MySessionManager.init()

    var session:URLSession = URLSession.shared
    
    private override init() {
        super.init()
        self.initRequestSession()
    }
    
    private func initRequestSession() {
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        config.networkServiceType = NSURLRequest.NetworkServiceType.default
        config.allowsCellularAccess = true
        config.isDiscretionary = true
        
        session = URLSession.init(configuration: config, delegate: self, delegateQueue: nil)
        
//        self.sendRequestWith(data: nil)
        
    }
    
    private func createRequestWith(data:Data) -> NSMutableURLRequest {
        let req: NSMutableURLRequest = NSMutableURLRequest.init()
        req.url = URL.init(string: url)
        req.httpMethod = "POST"
        req.httpBody = data;
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        return req
    }
    
    public func sendRequestWith(data:Data) {
        
        let req = self.createRequestWith(data: data)
        
        let task:URLSessionDataTask = session.dataTask(with: req as URLRequest)
        
        task.resume()
        
    }
    
    public func downloadWithUrl(downloadUrl:String) {
        
        let task:URLSessionDownloadTask = session.downloadTask(with: URL.init(string: downloadUrl)!)
        
        task.resume()
        
    }
    
    /************************ MARK session task delegate ************************/
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("\(type(of: self)) \(#function) line: \(#line) ")
        
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodServerTrust {
            return
        }
        
        let serverTrust:SecTrust? = challenge.protectionSpace.serverTrust;
        assert(serverTrust != nil, "serverTrust is nil")
        //导入CA证书（Certification Authority，支持SSL证书以及自签名的CA）
        let cerPath = Bundle.main.path(forResource: "PKIRootCA", ofType: "der")//自签名证书
//        let cerPath = Bundle.main.path(forResource: "rsa2048rootca", ofType: "der")//自签名证书

        var certData:Data?
        do {
            certData = try Data.init(contentsOf: URL.init(fileURLWithPath: cerPath!))
        } catch {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return
        }

        if (certData == nil) {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        let caRef:SecCertificate? = SecCertificateCreateWithData(kCFAllocatorDefault, certData! as CFData)
        if (caRef == nil) {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        let caArray:Array = [caRef];
        var status:OSStatus = SecTrustSetAnchorCertificates(serverTrust!, caArray as CFArray)
        if (status != errSecSuccess) {

            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        var originalPolicies:CFArray?;
        SecTrustCopyPolicies(serverTrust!, &originalPolicies);
        //kSecRevocationRequirePositiveResponse 对新地址有问题
        let revocationPolicy:SecPolicy? = SecPolicyCreateRevocation(kSecRevocationOCSPMethod | kSecRevocationRequirePositiveResponse)
        var policies:Array<SecPolicy> = (originalPolicies as! Array)
        policies.append(revocationPolicy!)

        status = SecTrustSetPolicies(serverTrust!, policies as CFTypeRef)
        if (status != errSecSuccess) {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        var result:SecTrustResultType = SecTrustResultType.invalid
        status = SecTrustEvaluate(serverTrust!, &result);
        print("stutas: \(status), Result:  \(result.rawValue)");

        if (status != errSecSuccess || (result != SecTrustResultType.unspecified && result != SecTrustResultType.proceed)) {
            print("error; not allow connect");
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }
        // 创建凭据对象
        let credential:URLCredential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        // 通过completionHandler告诉服务器信任证书
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("\(type(of: self)) \(#function) line: \(#line) \(String(describing: error?.localizedDescription))")
    }
    
    /************************ MARK  Session Data Delegate ************************/
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("\(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("\(type(of: self)) \(#function) line: \(#line) \(data)")
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            print("\(dict)")
        } catch  {
            let str:String? = String(data: data, encoding: String.Encoding.utf8)
            print("\(String(describing: str))")
        }
    }
    
    /************************ MARK Session Download Delegate ************************/
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(totalBytesWritten / totalBytesExpectedToWrite)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\(location)")
    }
    
    
}
