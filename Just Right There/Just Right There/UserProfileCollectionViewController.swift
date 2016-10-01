//
//  UserProfileCollectionViewController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import Social
import FirebaseDatabase

private let userProfileReuseIdentifier = "userProfileCell"

class UserProfileCollectionViewController: UICollectionViewController,
    UIActionSheetDelegate,
    UserProfileCellDelegate,
    UserProfileHeaderDelegate,
    UserProfileViewModelDelegate,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate {
    
    enum UserState {
        case Journal
        case Starred
    }
    
    var viewModel: UserProfileViewModel
    var headerView: UserProfileHeaderView?
    var state: UserState
    weak var headerDelegate: UserProfileDelegate?
    
    init(userViewModel: UserProfileViewModel) {
        viewModel = userViewModel
        
        state = .Journal
        
        super.init(collectionViewLayout: UserProfileCollectionViewController.provideCollectionViewLayout())
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        viewModel.getUsername()
        viewModel.requestJournalData()
        viewModel.requestStarredData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 100)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 335.5)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 0.0, 50.0, 0.0)
        flowLayout.itemSize = CGSizeMake(screenWidth - 24.0, 192)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.emptyDataSetSource = self
            collectionView.emptyDataSetDelegate = self
            collectionView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            //collectionView.registerClass(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: userProfileReuseIdentifier)
            collectionView.registerClass(HomeFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: userProfileReuseIdentifier)
        }
        
        headerDelegate?.numberOfItemsInSection(viewModel.journals.count, starred: viewModel.starred.count)
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let collectionView = collectionView {
            viewModel.getUsername()
            viewModel.requestJournalData()
            viewModel.requestStarredData()
            headerDelegate?.numberOfItemsInSection(viewModel.journals.count, starred: viewModel.starred.count)
            collectionView.reloadData()
        }
        
        if headerView != nil {
            let username = viewModel.getUsername()
            headerView?.nameLabel.text = username
            headerDelegate = headerView
            headerDelegate?.numberOfItemsInSection(viewModel.journals.count, starred: viewModel.starred.count)
            if let picture = NSUserDefaults.standardUserDefaults().stringForKey("picture") {
                headerView?.profileImageView.setImage(UIImage(named: "\(picture)"), forState: .Normal)
            } else {
                headerView?.profileImageView.setImage(UIImage(named: "alien-head"), forState: .Normal)
            }
        }
        
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: DZNEmptyDataSet
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "snooze")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if state == .Journal {
            let title = "No Dreams yet"
            let myMutableString = NSMutableAttributedString(
                string: title,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Montserrat",
                    size: 16.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
            return myMutableString
        } else {
            let title = "No Upvotes yet"
            let myMutableString = NSMutableAttributedString(
                string: title,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Montserrat",
                    size: 16.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
            return myMutableString
        }
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if state == .Journal {
            let description = "You can add a new dream by tapping on the + button at the bottom of your screen."
            let myMutableString = NSMutableAttributedString(
                string: description,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Courier",
                    size: 14.0)!, NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.74)])
            return myMutableString
        } else {
            let description = "You can upvote dreams that you like while reading on the home screen, and they'll be saved here."
            let myMutableString = NSMutableAttributedString(
                string: description,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Courier",
                    size: 14.0)!, NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.74)])
            return myMutableString
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numJournals = viewModel.journals.count
        let numStarred = viewModel.starred.count
        headerDelegate?.numberOfItemsInSection(numJournals, starred: numStarred)
        if state == .Journal {
            return numJournals
        } else {
            return numStarred
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(userProfileReuseIdentifier, forIndexPath: indexPath) as?HomeFeedImageCollectionViewCell
        
        if state == .Journal {
            cell?.dream = viewModel.journals[indexPath.row]
        } else {
            cell?.dream = viewModel.starred[indexPath.row]
        }
        
        return cell!
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if state == .Journal {
            let vc = UserDreamViewController(title: viewModel.journals[indexPath.row].title, author: viewModel.journals[indexPath.row].author, text: viewModel.journals[indexPath.row].text, id: viewModel.journals[indexPath.row].id)
            presentViewController(vc, animated: true, completion: nil)
        } else {
            let vc = UserDreamViewController(title: viewModel.starred[indexPath.row].title, author: viewModel.starred[indexPath.row].author, text: viewModel.starred[indexPath.row].text, id: viewModel.starred[indexPath.row].id)
            presentViewController(vc, animated: true, completion: nil)
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            
            if headerView == nil {
                headerView = cell
                headerView?.delegate = self
                if let username = viewModel.username {
                    headerView?.nameLabel.text = username
                    headerView?.collapseNameLabel.text = username
                }
            }
            return headerView!
        }
        return UICollectionReusableView()
    }
    
    func presentProfileImagePicker() {
        let pickerVC = ProfileIconPickerView()
        presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    // Header delegate
    func profileImageTapped() {
        presentProfileImagePicker()
    }
    
    func journalTabSelected() {
        state = .Journal
        collectionView?.reloadData()
    }
    
    func starredTabSelected() {
        state = .Starred
        collectionView?.reloadData()
    }
    
    func settingsSelected() {
        let settingsVC = UserSettingViewController()
        presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    func shareTapped(title: String, author: String, text: String, id: String, date: String) {
        viewModel.shareTitle = title
        viewModel.shareAuthor = author
        viewModel.shareText = text
        viewModel.shareId = id
        viewModel.shareDate = date
        
        if state == .Journal {
            let actionSheet = UIActionSheet(title: "Share to", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil, otherButtonTitles: "Dreamscape", "Twitter", "Facebook")
            actionSheet.showInView(view)
        } else {
            let actionSheet = UIActionSheet(title: "Share to", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil,otherButtonTitles: "Twitter", "Facebook")
            actionSheet.showInView(view)
        }
    }
    
    func dataDidLoad() {
        collectionView?.reloadData()
        self.headerDelegate?.numberOfItemsInSection(self.viewModel.journals.count, starred: viewModel.starred.count)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if state == .Journal {
            switch buttonIndex {
            case 0:
                print(")")
            case 1:
                let dreamDictionary = ["title":viewModel.shareTitle, "author":viewModel.shareAuthor, "text":viewModel.shareText, "date":viewModel.shareDate, "stars":0]
                
                FIRDatabase.database().reference().child("/feed").child("\(viewModel.shareId)").setValue(dreamDictionary)
            case 2:
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 3:
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        } else {
            switch buttonIndex {
            case 0:
                print(")")
            case 1:
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText("Share on Twitter")
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 2:
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    twitterSheet.setInitialText("Share on Facebook")
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }
}

protocol UserProfileDelegate: class {
    func numberOfItemsInSection(journals: Int, starred: Int)
}
