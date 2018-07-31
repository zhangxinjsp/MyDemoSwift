//
//  MySecureViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/27.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

enum SecureType: String {
    case MD5
    case SHA1
    case SHA224
    case SHA512
    case def
}

class MySecureViewController: MyBaseViewController {
    
    let textField = UITextField.init()
    let encryptLabel = UILabel.init()
    let decryptLabel = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK 需要桥接文件导入  #import <CommonCrypto/CommonDigest.h>
        initControls()
        
        encrypt(encryptData: "zhangxin")
//        let str = secure(text: "zhangxin", type: CCAlgorithm(kCCAlgorithmAES), operation: CCOperation(kCCEncrypt), key: "des")
//        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(String(describing: str))>")
//        //        bt1P8RsH+OZO3O7kinEFPQ==
//        let str1 = secure(text: str!, type: CCAlgorithm(kCCAlgorithmAES), operation: CCOperation(kCCDecrypt), key: "des")
//
//        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(String(describing: str1))>")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initControls() {
        textField.text = "xinaaa"
        textField.textAlignment = NSTextAlignment.center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.red
        self.view.addSubview(textField)
        
        encryptLabel.translatesAutoresizingMaskIntoConstraints = false
        encryptLabel.textAlignment = NSTextAlignment.center
        encryptLabel.numberOfLines = 0
        encryptLabel.text = "asdt"
        self.view.addSubview(encryptLabel)
        
        decryptLabel.translatesAutoresizingMaskIntoConstraints = false
        decryptLabel.textAlignment = NSTextAlignment.center
        decryptLabel.numberOfLines = 0
        decryptLabel.text = "asdt"
        self.view.addSubview(decryptLabel)
        
        var viewsDict:Dictionary = ["textField" : textField,
                                    "encryptLabel" : encryptLabel,
                                    "decryptLabel" : decryptLabel,]
        
        let titles:[SecureType] = [.MD5, .SHA1, .SHA224, .SHA512, .def, .def]
        
        let itemInRow = 3
        let rowCount = (titles.count + itemInRow - 1) / 3
        
        var Vstr:String = "V:|-64-[textField(45)]-0-[encryptLabel(100)]-0-[decryptLabel(textField)]"
        
        for i in 0..<rowCount {
            var Hstr:String = "H:|"
            for j in 0..<itemInRow {
                let index = i * itemInRow + j
                if index >= titles.count {
                    break
                }
                let btn = UIButton.init()
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.tag = index
                btn.setTitle(titles[index].rawValue, for: UIControlState.normal)
                btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                btn.addTarget(self, action: #selector(secureAction(button:)), for: UIControlEvents.touchUpInside)
                self.view.addSubview(btn)

                let key = String.init(format: "btn%d", index)

                viewsDict[key] = btn

                Hstr = Hstr.appendingFormat("-0-[%@(btn0)]", key)

            }
            Hstr = Hstr + "-0-|"
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: Hstr, options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
            Vstr = Vstr.appendingFormat("-0-[btn%d(btn0)]", i * itemInRow)
        }
        
        Vstr = Vstr.appendingFormat("-(>=0)-|")
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: Vstr, options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textField]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[encryptLabel]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[decryptLabel]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDict))
        
        
    }
    
    @objc func secureAction(button:UIButton) {
        textField.resignFirstResponder()
        
        let tag:SecureType = SecureType(rawValue: button.currentTitle!)!
        
        var encryptStr = ""
        var decryptStr = ""
        
        switch tag {
        case .MD5:
            encryptStr = md5Secure(encryptStr: textField.text!)
            decryptStr = "can not decrypt"
        case .SHA1:
            encryptStr = sha1Secure(encryptStr: textField.text!)
            decryptStr = "can not decrypt"
        case.SHA224:
            encryptStr = sha224Secure(encryptStr: textField.text!)
            decryptStr = "can not decrypt"
        case.SHA512:
            encryptStr = sha512Secure(encryptStr: textField.text!)
            decryptStr = "can not decrypt"
        default:
            encryptStr = "default"
            decryptStr = "defalut"
        }
        
        encryptLabel.text = encryptStr
        decryptLabel.text = decryptStr
        
    }

    //MARK MD5 and SHA
    func md5Secure(encryptStr: String) -> String {
        let cStr:[CChar] = encryptStr.cString(using: String.Encoding.utf8)!;
        
        let strLength = CC_LONG(strlen(cStr))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cStr, strLength, result)
 
        var secureStr:String = ""
        for i in 0..<CC_MD5_DIGEST_LENGTH {
            secureStr = secureStr.appendingFormat("%02X", result[Int(i)])
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(secureStr)>")
        return secureStr
    }

    func sha1Secure(encryptStr: String) -> String {
        let cStr:[CChar] = encryptStr.cString(using: String.Encoding.utf8)!;
        
        let strLength = CC_LONG(strlen(cStr))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(cStr, strLength, result)
        
        var secureStr:String = ""
        for i in 0..<CC_SHA1_DIGEST_LENGTH {
            secureStr = secureStr.appendingFormat("%02X", result[Int(i)])
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(secureStr)>")
        return secureStr
    }
    
    func sha224Secure(encryptStr: String) -> String {
        let cStr:[CChar] = encryptStr.cString(using: String.Encoding.utf8)!;
        
        let strLength = CC_LONG(strlen(cStr))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA224_DIGEST_LENGTH))
        CC_SHA224(cStr, strLength, result)
        
        var secureStr:String = ""
        for i in 0..<CC_SHA224_DIGEST_LENGTH {
            secureStr = secureStr.appendingFormat("%02X", result[Int(i)])
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(secureStr)>")
        return secureStr
    }
    
    func sha512Secure(encryptStr: String) -> String {
        let cStr:[CChar] = encryptStr.cString(using: String.Encoding.utf8)!;
        
        let strLength = CC_LONG(strlen(cStr))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(cStr, strLength, result)
        
        var secureStr:String = ""
        for i in 0..<CC_SHA512_DIGEST_LENGTH {
            secureStr = secureStr.appendingFormat("%02X", result[Int(i)])
        }
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(secureStr)>")
        return secureStr
    }
    
    //MARK des aes 加解密
    
    func secure(text:String, type:CCAlgorithm, operation:CCOperation, key:String) -> String? {
        
        var dataIn:UnsafeRawPointer
        var dataInLength:Int = 0
        
        switch operation {
        case UInt32(kCCEncrypt):
            let encryptData:Data = text.data(using: String.Encoding.utf8)!
            dataInLength = encryptData.count
            dataIn = UnsafeRawPointer((encryptData as NSData).bytes)
            
        case UInt32(kCCDecrypt):
            let decryptData:Data = Data.init(base64Encoded: text, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!//转成utf-8并decode
            dataInLength = decryptData.count
            dataIn = UnsafeRawPointer((decryptData as NSData).bytes)
            
        default:
            return ""
        }
        
        let keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySizeAES256)

        let bufferData = NSMutableData(length: Int(dataInLength) + kCCBlockSizeAES128)!
        let dataOut = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let dataOutAvailable = size_t(bufferData.length)
        var dataOutMoved:Int = 0
//            UnsafeMutableRawPointer? = malloc( dataOutAvailable * MemoryLayout.size(ofValue: UInt8.self))
//        memset(dataOut, 0x0, dataOutAvailable)//将已开辟内存空间buffer的首 1 个字节的值设为值 0
        
        let initIv:String = "12345678"
        
        let status = CCCrypt(operation, type, CCOptions(kCCOptionPKCS7Padding + kCCOptionECBMode), keyBytes, keyLength, nil, dataIn, dataInLength, dataOut, dataOutAvailable, &dataOutMoved)
//        CCCrypt(<#T##op: CCOperation##CCOperation#>, <#T##alg: CCAlgorithm##CCAlgorithm#>, <#T##options: CCOptions##CCOptions#>, <#T##key: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##keyLength: Int##Int#>, <#T##iv: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##dataIn: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##dataInLength: Int##Int#>, <#T##dataOut: UnsafeMutableRawPointer!##UnsafeMutableRawPointer!#>, <#T##dataOutAvailable: Int##Int#>, <#T##dataOutMoved: UnsafeMutablePointer<Int>!##UnsafeMutablePointer<Int>!#>)
        print("\(status)")

        var str:String? = nil
        if operation == kCCEncrypt {
            let data = Data.init(bytes: dataOut, count: dataOutMoved)
            str = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        } else {
            let data = Data.init(bytes: dataOut, count: dataOutMoved)
            str = String.init(data: data, encoding: String.Encoding.utf8)
        }
        
        return str!
    }
    
    
    
    func encrypt(encryptData:String){
        let key = "des"
        let inputData : Data = encryptData.data(using: String.Encoding.utf8)!
        
        let keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        
        let cryptStatus = CCCrypt(
            UInt32(kCCEncrypt),
            UInt32(kCCAlgorithm3DES),
            UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
            keyBytes,
            keyLength,
            nil,
            dataBytes,
            dataLength,
            bufferPointer,
            bufferLength,
            &bytesDecrypted)
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            decrypt(inputData: bufferData as Data)
        } else {
            print("加密过程出错: \(cryptStatus)")
        }
    }
    
    func decrypt(inputData : Data){
        let keyData: Data = "des".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        
        let cryptStatus = CCCrypt(
            UInt32(kCCDecrypt),
            UInt32(kCCAlgorithm3DES),
            UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
            keyBytes,
            keyLength,
            nil,
            dataBytes,
            dataLength,
            bufferPointer,
            bufferLength,
            &bytesDecrypted)
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            let clearDataAsString = NSString(data: bufferData as Data, encoding: String.Encoding.utf8.rawValue)
            print("解密后的内容：\(clearDataAsString! as String)")
        } else {
            print("解密过程出错: \(cryptStatus)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
