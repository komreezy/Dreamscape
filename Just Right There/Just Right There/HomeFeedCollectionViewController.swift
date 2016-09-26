//
//  HomeFeedCollectionViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

private let homeFeedReuseIdentifier = "homeFeedCell"

class HomeFeedCollectionViewController: UICollectionViewController,
HomeFeedViewModelDelegate,
HomeFeedCellDelegate,
UserProfileViewModelDelegate {

    var viewModel: HomeFeedViewModel
    var userDefaults: NSUserDefaults
    var refreshControl: UIRefreshControl
    var loadingLabel: UILabel
    
    let alphabet = ["a","b","c","d","e","f","g",
                    "h","i","j","k","l","m","n",
                    "o","p","q","r","s","t","u",
                    "v","w","x","y","z",]
    
    init(homeFeedViewModel: HomeFeedViewModel) {
        viewModel = homeFeedViewModel
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.primaryDarkBlue()
        
        loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Loading..."
        loadingLabel.font = UIFont.systemFontOfSize(20.0)
        
        super.init(collectionViewLayout: HomeFeedCollectionViewController.provideCollectionViewLayout())
        
        view.backgroundColor = UIColor.whiteColor()
        viewModel.delegate = self
        refreshControl.addTarget(self, action: #selector(HomeFeedCollectionViewController.refresh), forControlEvents: .ValueChanged)
        
        collectionView!.addSubview(refreshControl)
        view.addSubview(loadingLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        
        // Register cell classes
        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.alwaysBounceVertical = true
            collectionView.registerClass(HomeFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        }
        
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .ScaleAspectFit
        logoImageView.frame = CGRectMake(0, 0, 100, 30)
        navigationItem.titleView = logoImageView
        
        let loadingTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "loadingTimeout", userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        if userDefaults.boolForKey("user") == false {
            let vc = SignupViewController()
            presentViewController(vc, animated: true, completion: nil)
        }
        
        if let collectionView = collectionView {
            viewModel.requestStarredData()
            collectionView.reloadData()
        }
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(screenWidth, 160)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
        return flowLayout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dreamDictionary.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! HomeFeedImageCollectionViewCell
        
        cell.delegate = self
        cell.dream = viewModel.dreamDictionary[indexPath.row]
        
        let letter: String = viewModel.dreamDictionary[indexPath.row].author[0..<1]
            let index = alphabet.indexOf(letter.lowercaseString)
        
            if index == 0 || index == 14 {
                cell.imageView.setImage(UIImage(named: "alien-head"), forState: .Normal)
            } else if index == 1 || index == 14 {
                cell.imageView.setImage(UIImage(named: "atom"), forState: .Normal)
            } else if index == 2 || index == 15 {
                cell.imageView.setImage(UIImage(named: "brain"), forState: .Normal)
            } else if index == 3 || index == 16 {
                cell.imageView.setImage(UIImage(named: "circus-camel"), forState: .Normal)
            } else if index == 4 || index == 17 {
                cell.imageView.setImage(UIImage(named: "cloud-and-moon"), forState: .Normal)
            } else if index == 5 || index == 18 {
                cell.imageView.setImage(UIImage(named: "earth-globe"), forState: .Normal)
            } else if index == 6 || index == 19 {
                cell.imageView.setImage(UIImage(named: "fire-gear"), forState: .Normal)
            } else if index == 7 || index == 20 {
                cell.imageView.setImage(UIImage(named: "flask"), forState: .Normal)
            } else if index == 8 || index == 21 {
                cell.imageView.setImage(UIImage(named: "giraffe"), forState: .Normal)
            } else if index == 9 || index == 22 {
                cell.imageView.setImage(UIImage(named: "hot-air-balloon"), forState: .Normal)
            } else if index == 10 || index == 23 {
                cell.imageView.setImage(UIImage(named: "islamic-art-1"), forState: .Normal)
            } else if index == 11 || index == 24 {
                cell.imageView.setImage(UIImage(named: "islamic-art-2"), forState: .Normal)
            } else if index == 12 || index == 25 {
                cell.imageView.setImage(UIImage(named: "oil-lamp"), forState: .Normal)
            } else if index == 13 || index == 26 {
                cell.imageView.setImage(UIImage(named: "saturn"), forState: .Normal)
            }
        
            if starredIds.contains(cell.id!) {
                cell.starButton.setImage(UIImage(named: "goldstar"), forState: .Normal)
                cell.starLabel.textColor = UIColor.flatGold()
            } else {
                cell.starButton.setImage(UIImage(named: "greystar"), forState: .Normal)
                cell.starLabel.textColor = UIColor.flatGrey()
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        let dreamViewController = DreamViewController(dream: viewModel.dreamDictionary[indexPath.row])
        navigationController?.pushViewController(dreamViewController, animated: true)
    }
    
    func addButtonTapped() {
        let hasAgreedToRules = NSUserDefaults.standardUserDefaults().boolForKey("agreed")
        
        if hasAgreedToRules {
            let addDreamViewController = NewDreamViewController()
            presentViewController(addDreamViewController, animated: true, completion: nil)
        } else {
            let agreeViewController = AgreeRulesViewController()
            presentViewController(agreeViewController, animated: true, completion: nil)
        }
    }
    
    func dataDidLoad() {
        collectionView?.reloadSections(NSIndexSet(index: 0))
        loadingLabel.hidden = true
    }
    
    func refresh() {
        viewModel.requestData()
        collectionView?.reloadSections(NSIndexSet(index: 0))
        refreshControl.endRefreshing()
    }
    
    func loadingTimeout() {
        loadingLabel.text = "Check Internet Connection"
    }
    
    // MARK: HomeFeedCellDelegate
    func starTapped() {
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    func setupLayout() {
        view.addConstraints([
            loadingLabel.al_centerY == view.al_centerY - 10,
            loadingLabel.al_centerX == view.al_centerX
        ])
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}
