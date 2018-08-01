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
    case AES
    case _3DES
    case RC4
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

        publicKey()
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
        
        let titles:[SecureType] = [.MD5, .SHA1, .SHA224, .SHA512, .AES, ._3DES, .RC4, .def, .def]
        
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
        case.AES:
            encryptStr = secure(operation: CCOperation(kCCEncrypt), text: textField.text!, key: "key", alg: CCAlgorithm(kCCAlgorithmAES), keySize: kCCKeySizeAES256, blockSize: kCCBlockSizeAES128)!
            decryptStr = secure(operation: CCOperation(kCCDecrypt), text: encryptStr, key: "key", alg: CCAlgorithm(kCCAlgorithmAES), keySize: kCCKeySizeAES256, blockSize: kCCBlockSizeAES128)!
        case._3DES:
            encryptStr = secure(operation: CCOperation(kCCEncrypt), text: textField.text!, key: "key", alg: CCAlgorithm(kCCAlgorithm3DES), keySize: kCCKeySize3DES, blockSize: kCCBlockSize3DES)!
            decryptStr = secure(operation: CCOperation(kCCDecrypt), text: encryptStr, key: "key", alg: CCAlgorithm(kCCAlgorithm3DES), keySize: kCCKeySize3DES, blockSize: kCCBlockSize3DES)!
        case.RC4:
            encryptStr = secure(operation: CCOperation(kCCEncrypt), text: textField.text!, key: "key", alg: CCAlgorithm(kCCAlgorithmRC4), keySize: kCCKeySizeMaxRC4, blockSize: kCCBlockSizeRC2)!
            decryptStr = secure(operation: CCOperation(kCCDecrypt), text: encryptStr, key: "key", alg: CCAlgorithm(kCCAlgorithmRC4), keySize: kCCKeySizeMaxRC4, blockSize: kCCBlockSizeRC2)!
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
    func secure(operation:CCOperation, text:String, key:String, alg:CCAlgorithm, keySize:Int, blockSize:Int) -> String? {
        
        var keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyLength = size_t(keySize)
        while keyData.count < keyLength {
            keyData.append("a".data(using: String.Encoding.utf8)!)
        }
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        
        let data:Data
        if operation == kCCEncrypt {
            data = text.data(using: String.Encoding.utf8)!
        } else if operation == kCCDecrypt {
            data = Data.init(base64Encoded: text, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!//转成utf-8并decode
        } else {
            return ""
        }
        let dataInLength:Int = data.count
        let dataIn:UnsafeRawPointer = UnsafeRawPointer((data as NSData).bytes)

        let bufferData = NSMutableData(length: Int(dataInLength) + blockSize)!
        let dataOut = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let dataOutAvailable = size_t(bufferData.length)
        var dataOutMoved:Int = 0
        
        let status = CCCrypt(operation, alg, CCOptions(kCCOptionPKCS7Padding + kCCOptionECBMode), keyBytes, keyLength, nil, dataIn, dataInLength, dataOut, dataOutAvailable, &dataOutMoved)

        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) <\(status)>")

        var str:String? = nil
        if operation == kCCEncrypt {
            let data = Data.init(bytes: dataOut, count: dataOutMoved)
            str = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        } else if operation == kCCDecrypt {
            let data = Data.init(bytes: dataOut, count: dataOutMoved)
            str = String.init(data: data, encoding: String.Encoding.utf8)
        }
        return str!
    }
    
    /*
     RSA 加解密使用
     
     证书生成
     
     openssl genrsa -out private_key.pem 1024
     Generating RSA private key, 1024 bit long modulus
     ...........++++++
     ...........................................++++++
     e is 65537 (0x10001)
     zhangxin-2:Desktop archermind$ openssl req -new -key private_key.pem -out rsaCertReq.csr
     You are about to be asked to enter information that will be incorporated
     into your certificate request.
     What you are about to enter is what is called a Distinguished Name or a DN.
     There are quite a few fields but you can leave some blank
     For some fields there will be a default value,
     If you enter '.', the field will be left blank.
     -----
     Country Name (2 letter code) [AU]:cn
     State or Province Name (full name) [Some-State]:jiangsu
     Locality Name (eg, city) []:nanjing
     Organization Name (eg, company) [Internet Widgits Pty Ltd]:test
     Organizational Unit Name (eg, section) []:tes
     Common Name (e.g. server FQDN or YOUR name) []:test
     Email Address []:test@test.com
     
     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     zhangxin-2:Desktop archermind$ openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private_key.pem -out rsaCert.crt
     Signature ok
     subject=/C=cn/ST=jiangsu/L=nanjing/O=test/OU=tes/CN=test/emailAddress=test@test.com
     Getting Private key
     zhangxin-2:Desktop archermind$ openssl x509 -outform der -in rsaCert.crt -out public_key.der
     zhangxin-2:Desktop archermind$ openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
     Enter Export Password:
     Verifying - Enter Export Password:
     zhangxin-2:Desktop archermind$
     zhangxin-2:Desktop archermind$ openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout
     writing RSA key
     zhangxin-2:Desktop archermind$ openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt
     zhangxin-2:Desktop archermind$
     
     */
    func publicKey() -> SecKey {
        
        var publickey:SecKey? = nil
        var status:OSStatus = 0
        if publickey == nil {
            let keyPath:String? = Bundle.main.path(forResource: "public_key", ofType: "der")
            
            var keyData:CFData? = nil
            
            do {
                let fileData:Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: keyPath!))
                
                keyData = fileData! as CFData
            } catch {
            }
            
            let cert:SecCertificate? = SecCertificateCreateWithData(kCFAllocatorDefault, keyData!)
            
//            if #available(iOS 10.3, *) {
//                publickey = SecCertificateCopyPublicKey(cert!)
//            } else {
                let policy:SecPolicy = SecPolicyCreateBasicX509();
                var trust:SecTrust? = nil
                
                status = SecTrustCreateWithCertificates(cert!, policy, &trust);
                publickey = SecTrustCopyPublicKey(trust!)
//            }
        }
        return publickey!   
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
