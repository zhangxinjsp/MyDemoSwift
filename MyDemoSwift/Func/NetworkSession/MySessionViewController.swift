//
//  MySessionViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MySessionViewController: MyBaseViewController {

    let textView:UITextView = UITextView.init()
    let imageView:UIImageView = UIImageView.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initSubcontrols()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initSubcontrols() {
        
        let reqBtn:UIButton = UIButton.init()
        reqBtn.translatesAutoresizingMaskIntoConstraints = false
        reqBtn.addTarget(self, action: #selector(requestDataFromTsp(sender:)), for: UIControlEvents.touchUpInside)
        reqBtn.backgroundColor = UIColor.red
        reqBtn.setTitle("req", for: UIControlState.normal)
        self.view.addSubview(reqBtn)
        
        let downloadBtn:UIButton = UIButton.init()
        downloadBtn.translatesAutoresizingMaskIntoConstraints = false
        downloadBtn.addTarget(self, action: #selector(downloadImage(sender:)), for: UIControlEvents.touchUpInside)
        downloadBtn.backgroundColor = UIColor.red
        downloadBtn.setTitle("download", for: UIControlState.normal)
        self.view.addSubview(downloadBtn)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.red
        self.view.addSubview(textView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.green
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.tag = 100
        self.view.addSubview(imageView)
        
        let viewDict = ["reqBtn" : reqBtn,
                        "downloadBtn" : downloadBtn,
                        "textView" : textView,
                        "imageView" : imageView,
                        ]
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[reqBtn]-[downloadBtn(reqBtn)]-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(70)-[reqBtn(44)]-[textView]-[imageView(textView)]-60-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: viewDict))
        
        self.view.addConstraint(reqBtn.bottomAnchor.constraint(equalTo: downloadBtn.bottomAnchor))
        self.view.addConstraint(textView.rightAnchor.constraint(equalTo: downloadBtn.rightAnchor))
        self.view.addConstraint(imageView.rightAnchor.constraint(equalTo: downloadBtn.rightAnchor))
    }
    
    @objc func downloadImage(sender:UIButton?) {
        MySessionManager.shared.downloadWithUrl(downloadUrl: "https://sh.syan.com.cn:7756/cherym31t/m31t/download/?id=My5qcGc=") { (downloadUrl, fileName, error) in
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: downloadUrl))")
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: fileName))")
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error))")
            self.imageView.image = UIImage.init(contentsOfFile: fileName as! String)
        }
    }
    
    @objc func requestDataFromTsp(sender:UIButton) {
        let dict:Dictionary = [
            "businessId" : "M31T",
            "data" : [:],
            "os" : "2",
            "serviceType" : "getBannerList",
            "requestId" : "5330E853-237D-4B63-AF76-B409A6F8D8BD",
            "version" : "0100"
            ] as [String : Any]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: data))")
            MySessionManager.shared.sendRequestWith(mode: data) { (req, resp, error) in
                do {
                    let aaa = try JSONSerialization.jsonObject(with: req as! Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: aaa))")
                } catch {
                }
                
                self.textView.text = String(describing: resp)
                
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: resp))")
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error))")
            }
        } catch {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) ")
        }
    }

}
