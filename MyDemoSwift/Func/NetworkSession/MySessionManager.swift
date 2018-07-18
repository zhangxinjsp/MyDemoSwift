//
//  MySessionConnection.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit
import Foundation


let url:String = "https://203.93.252.29:18088/cherym31t/command"
//let url:String = "https://203.93.252.40:8088/cherym31t/command";

class MySessionManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
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
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("\(type(of: self)) \(#function) line: \(#line) ")
        
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodServerTrust {
            return
        }
        
        /*
         SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
         NSCAssert(serverTrust != nil, @"serverTrust is nil");
         //导入CA证书（Certification Authority，支持SSL证书以及自签名的CA）
         NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"PKIRootCA" ofType:@"der"];//自签名证书
         //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"rsa2048rootca" ofType:@"der"];//自签名证书
         NSData* certData = [NSData dataWithContentsOfFile:cerPath];
         if (certData == nil) {
         LOGINFO(@"certificate file is empty");
         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         return;
         }
         
         SecCertificateRef caRef = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certData);
         if (caRef == nil) {
         LOGINFO(@"certificate create failed ");
         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         return;
         }
         
         NSArray *caArray = @[(__bridge id)(caRef)];
         
         OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
         if (status != errSecSuccess) {
         LOGINFO(@"set trust anchor certificate failed:%d", status);
         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         return;
         }
         
         CFArrayRef originalPolicies;
         SecTrustCopyPolicies(serverTrust, &originalPolicies);
         //kSecRevocationRequirePositiveResponse 对新地址有问题
         SecPolicyRef revocationPolicy = SecPolicyCreateRevocation(kSecRevocationOCSPMethod | kSecRevocationRequirePositiveResponse);
         NSArray *policies = [(__bridge NSArray *)originalPolicies arrayByAddingObject:(__bridge id)revocationPolicy];
         
         status = SecTrustSetPolicies(serverTrust, (__bridge CFTypeRef _Nonnull)(policies));
         if (status != errSecSuccess) {
         LOGINFO(@"set policies error status:%d", status);
         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         return;
         }
         
         SecTrustResultType result = kSecTrustResultInvalid;
         status = SecTrustEvaluate(serverTrust, &result);
         LOGINFO(@"stutas: %d, Result: %d" , (int)status, result);
         
         if (status != errSecSuccess || (result != kSecTrustResultUnspecified && result != kSecTrustResultProceed)) {
         LOGINFO(@"error; not allow connect");
         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         return;
         }
         */
        
        // 创建凭据对象
        let credential:URLCredential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        
        // 通过completionHandler告诉服务器信任证书
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("\(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("\(type(of: self)) \(#function) line: \(#line) \(String(describing: error?.localizedDescription))")
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
    
    
    
    
    
}
