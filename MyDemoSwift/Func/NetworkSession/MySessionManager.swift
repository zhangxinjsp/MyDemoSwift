//
//  MySessionConnection.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit
import Foundation


private let url:String = "url";//信任站点

class MySessionManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    static let shared:MySessionManager = MySessionManager.init()
    
    var callbackDict:[Int : (Any?, Any?, Error?)->Swift.Void] = [:]
    var receiveDict:[Int : Any] = [:]
    var requestDict:[Int : Any] = [:]
    
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
    
    public func sendRequestWith(mode:Any, callback: @escaping (Any?, Any?, Error?)->Swift.Void) {
        
        let req = self.createRequestWith(data: mode as! Data)
        
        let task:URLSessionDataTask = session.dataTask(with: req as URLRequest)
        
        callbackDict.updateValue(callback, forKey: task.taskIdentifier)
        requestDict.updateValue(mode, forKey: task.taskIdentifier)
        task.resume()
    }
    
    public func downloadWithUrl(downloadUrl:String, callback: @escaping (Any?, Any?, Error?)->Swift.Void) {
        
        let task:URLSessionDownloadTask = session.downloadTask(with: URL.init(string: downloadUrl)!)
        callbackDict.updateValue(callback, forKey: task.taskIdentifier)
        requestDict.updateValue(downloadUrl, forKey: task.taskIdentifier)
        task.resume()
    }
    
    /************************ MARK session task delegate ************************/
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) ")
        
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodServerTrust {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) service authentication method is not trust")
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
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(error)")
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return
        }

        if (certData == nil) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) certificate is nil")
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        let caRef:SecCertificate? = SecCertificateCreateWithData(kCFAllocatorDefault, certData! as CFData)
        if (caRef == nil) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) certificate create failed")
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        let caArray:Array = [caRef];
        var status:OSStatus = SecTrustSetAnchorCertificates(serverTrust!, caArray as CFArray)
        if (status != errSecSuccess) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) set trust anchor certificate faileds")
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
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) set trust policy failed")
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }

        var result:SecTrustResultType = SecTrustResultType.invalid
        status = SecTrustEvaluate(serverTrust!, &result);
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) stutas: \(status), Result:  \(result.rawValue)");

        if (status != errSecSuccess || (result != SecTrustResultType.unspecified && result != SecTrustResultType.proceed)) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) error; not allow connect");
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil);
            return;
        }
        // 创建凭据对象
        let credential:URLCredential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        // 通过completionHandler告诉服务器信任证书
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error?.localizedDescription))")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(type(of: task))")
        
        if task.isKind(of: URLSessionDownloadTask.self) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) URLSessionDownloadTask id : \(task.taskIdentifier)")
        }
        if task.isKind(of: URLSessionDataTask.self) {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) URLSessionDataTask id : \(task.taskIdentifier)")
        }
        DispatchQueue.main.async {
            let callback:(Any?, Any?, Error?)->Swift.Void = self.callbackDict[task.taskIdentifier]!
            callback(self.requestDict[task.taskIdentifier], self.receiveDict[task.taskIdentifier], error)
        }
    }
    
    /************************ MARK  Session Data Delegate ************************/
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(data)")
        
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
            receiveDict.updateValue(dict, forKey: dataTask.taskIdentifier)
            
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(dict)")
        } catch  {
            let str:String? = String(data: data, encoding: String.Encoding.utf8)
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: str))")
        }
    }
    
    /************************ MARK Session Download Delegate ************************/
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) Download completion per : \(totalBytesWritten / totalBytesExpectedToWrite)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(location)")
        
        var fileName = downloadTask.originalRequest?.url?.query
        if fileName?.count == 0 {
            fileName = downloadTask.originalRequest?.url?.lastPathComponent
        }
        
        var cachesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let savePath = URL.init(fileURLWithPath: cachesPaths[0]).appendingPathComponent(fileName!)
        
        do {
            try FileManager.default.removeItem(at: savePath)
        } catch {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(error)")
        }
    
        do {
            try FileManager.default.moveItem(at: location, to: savePath)
            receiveDict.updateValue(savePath.path, forKey: downloadTask.taskIdentifier)
        } catch {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(error)")
        }
    }
    
    
}
