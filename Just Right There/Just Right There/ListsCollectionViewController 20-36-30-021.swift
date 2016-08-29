//
//  ListsCollectionViewController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 9/4/15.
//  Copyright (c) 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

let listCellReuseIdentifier = "listCell"

class ListsCollectionViewController: UICollectionViewController {
    var selectedIndex = 0
    
    init() {
        super.init(collectionViewLayout: ListsCollectionViewController.provideCollectionViewLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 60.0)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(ListsCollectionViewCell.self, forCellWithReuseIdentifier: listCellReuseIdentifier)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.lists.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(listCellReuseIdentifier, forIndexPath: indexPath) as! ListsCollectionViewCell
        
        cell.nameLabel.text = manager.lists[indexPath.row].title
        cell.itemCountLabel.text = String(0)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let navigationController = navigationController {
            manager.currentIndex = indexPath.row
            navigationController.pushViewController(ListDetailViewController(), animated: true)
        }
    }
}
