//
//  MySessionViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class MySessionViewController: MyBaseViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        /*
         {
         "businessId" : "M31T",
         "data" : {
         
         },
         "os" : "2",
         "serviceType" : "getBannerList",
         "requestId" : "5330E853-237D-4B63-AF76-B409A6F8D8BD",
         "version" : "0100"
         }
         */
        
        
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
            MySessionManager.shared.sendRequestWith(data: data)
        } catch {
            print("")
        }
        
        
//        MySessionManager.shared.downloadWithUrl(downloadUrl: "http://www.chery.cn/BrandShow/News?newsid=dc363897-9838-47fe-95b4-d3eeb14904d4")
        
        
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
