//
//  FuncMenuViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/17.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

enum FunctionDemo: String {
    case networkSession
    case runTime
    case test2
    case test3
}

class FuncMenuViewController: MyBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let funcItems:[FunctionDemo] = [.networkSession, .runTime, .test2, .test3]
    

    var layout:UICollectionViewFlowLayout? = UICollectionViewFlowLayout.init()
    
    var collection: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout?.scrollDirection = UICollectionViewScrollDirection.vertical
        layout?.minimumLineSpacing = 8.0
        layout?.minimumInteritemSpacing = 8.0
        layout?.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        layout?.itemSize = CGSize.init(width: self.view.bounds.size.width/3-20, height: 80)
        
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout!)
        collection?.delegate = self
        collection?.dataSource = self
        collection?.backgroundColor = UIColor.clear
        collection?.register(type(of: UICollectionViewCell.init()), forCellWithReuseIdentifier: "cellId")
        collection?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collection!)
        
        let viewDict:[String:Any] = ["collection":collection!]
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collection]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collection]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewDict))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        if cell == nil {
            cell = UICollectionViewCell.init()
        }
        cell?.backgroundColor = UIColor.gray
        
        var label:UILabel? = cell?.contentView.viewWithTag(100) as? UILabel
        
        if label == nil {
            label = UILabel.init()
            label?.tag = 100
            label?.numberOfLines = 0
            label?.textAlignment = NSTextAlignment.center
            label?.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addSubview(label!)
            
            cell?.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["label":label!]))
            cell?.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["label":label!]))
            
        }
        label?.text = funcItems[indexPath.row].rawValue
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(funcItems[indexPath.row].rawValue)")
        
        switch funcItems[indexPath.row] {
        case .networkSession:
            let ctl = MySessionViewController()
            ctl.navigationItem.title = FunctionDemo.networkSession.rawValue
            self.navigationController?.pushViewController(ctl, animated: true)
            
        case .runTime:
            let ctl = MyRunTimeViewController()
            ctl.navigationItem.title = FunctionDemo.runTime.rawValue
            self.navigationController?.pushViewController(ctl, animated: true)
            
        default:
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) table view did selected no")
        }
    }

}
