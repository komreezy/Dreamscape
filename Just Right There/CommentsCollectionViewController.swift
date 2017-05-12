//
//  CommentsCollectionViewController.swift
//  
//
//  Created by Komran Ghahremani on 5/8/17.
//
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentsCollectionViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: CommentsCollectionViewController.provideCollectionViewLayout())
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        // Register cell classes
        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
            collectionView.alwaysBounceVertical = true
            collectionView.register(HomeFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        }
        
        let logoImageView = UILabel()
        logoImageView.text = "comments".uppercased()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.white
        logoImageView.textAlignment = .center
        
        navigationItem.titleView = logoImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.main.bounds.size.width
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: screenWidth - 24.0, height: 192)
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 0.0, 50.0, 0.0)
        return flowLayout
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! HomeFeedImageCollectionViewCell
        
        return cell
    }
}
