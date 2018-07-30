//
//  MySecureViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/27.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MySecureViewController: MyBaseViewController {
    
    let textView = UITextView.init()
    let button = UIButton.init()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func md5Secure(encryptStr: String) -> String {
        let _:[CChar] = encryptStr.cString(using: String.Encoding.utf8)!;
        
        /*
         MARK 需要桥接文件导入  #import <CommonCrypto/CommonDigest.h>//md5

        var result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cStr, CC_LONG(strlen(cStr)), &digest)
        */
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 16)

        return String.init(format: "%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15])
        
 
    }

    func aaaaa() {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
