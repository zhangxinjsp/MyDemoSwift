//
//  ThirdMenuViewController.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/16.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

class ThirdMenuViewController: MyBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var layout:UICollectionViewFlowLayout? = UICollectionViewFlowLayout.init()
    
    var collection: UICollectionView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout?.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout?.minimumLineSpacing = 8.0
        layout?.minimumInteritemSpacing = 8.0
        layout?.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        layout?.itemSize = CGSize.init(width: 120, height: 40)
        
        collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 66, width: self.view.frame.width, height: 100), collectionViewLayout: layout!)
        collection?.delegate = self
        collection?.dataSource = self
        collection?.backgroundColor = UIColor.green
        collection?.register(type(of: UICollectionViewCell.init()), forCellWithReuseIdentifier: "cellId")
        self.view.addSubview(collection!)
    
        
        
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        if cell == nil {
            cell = UICollectionViewCell.init()
        }
        cell?.backgroundColor = UIColor.red
        return cell!
    }

}
