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
        case journal
        case starred
    }
    
    var viewModel: UserProfileViewModel
    var headerView: UserProfileHeaderView?
    var state: UserState
    weak var headerDelegate: UserProfileDelegate?
    
    init(userViewModel: UserProfileViewModel) {
        viewModel = userViewModel
        
        state = .journal
        
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
        let screenWidth = UIScreen.main.bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSize(width: screenWidth, height: 100)
        flowLayout.parallaxHeaderReferenceSize = CGSize(width: screenWidth, height: 335.5)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 0.0, 50.0, 0.0)
        flowLayout.itemSize = CGSize(width: screenWidth - 24.0, height: 192)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.emptyDataSetSource = self
            collectionView.emptyDataSetDelegate = self
            collectionView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            //collectionView.registerClass(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: userProfileReuseIdentifier)
            collectionView.register(HomeFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: userProfileReuseIdentifier)
        }
        
        headerDelegate?.numberOfItemsInSection(viewModel.journals.count, starred: viewModel.starred.count)
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            if let picture = UserDefaults.standard.string(forKey: "picture") {
                headerView?.profileImageView.setImage(UIImage(named: "\(picture)"), for: UIControlState())
            } else {
                headerView?.profileImageView.setImage(UIImage(named: "alien-head"), for: UIControlState())
            }
        }
        
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: DZNEmptyDataSet
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "snooze")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return view.frame.size.height * 0.25
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if state == .journal {
            let title = "No Dreams yet"
            let myMutableString = NSMutableAttributedString(
                string: title,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Montserrat",
                    size: 16.0)!, NSForegroundColorAttributeName: UIColor.white])
            return myMutableString
        } else {
            let title = "No Upvotes yet"
            let myMutableString = NSMutableAttributedString(
                string: title,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Montserrat",
                    size: 16.0)!, NSForegroundColorAttributeName: UIColor.white])
            return myMutableString
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if state == .journal {
            let description = "You can add a new dream by tapping on the + button at the bottom of your screen."
            let myMutableString = NSMutableAttributedString(
                string: description,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Courier",
                    size: 14.0)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.74)])
            return myMutableString
        } else {
            let description = "You can upvote dreams that you like while reading on the home screen, and they'll be saved here."
            let myMutableString = NSMutableAttributedString(
                string: description,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Courier",
                    size: 14.0)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.74)])
            return myMutableString
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numJournals = viewModel.journals.count
        let numStarred = viewModel.starred.count
        headerDelegate?.numberOfItemsInSection(numJournals, starred: numStarred)
        if state == .journal {
            return numJournals
        } else {
            return numStarred
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userProfileReuseIdentifier, for: indexPath) as?HomeFeedImageCollectionViewCell
        
        if state == .journal {
            cell?.dream = viewModel.journals[(indexPath as NSIndexPath).row]
            
            let id = viewModel.journals[(indexPath as NSIndexPath).row].id
            if starredIds.contains(id) {
                cell?.upvoteButton.isSelected = true
            } else {
                cell?.upvoteButton.isSelected = false
            }
            
            if downvoteIds.contains(id) {
                cell?.downvoteButton.isSelected = true
            } else {
                cell?.downvoteButton.isSelected = false
            }
        } else {
            cell?.dream = viewModel.starred[(indexPath as NSIndexPath).row]
            
            let id = viewModel.starred[(indexPath as NSIndexPath).row].id
            if starredIds.contains(id) {
                cell?.upvoteButton.isSelected = true
            } else {
                cell?.upvoteButton.isSelected = false
            }
            
            if downvoteIds.contains(id) {
                cell?.downvoteButton.isSelected = true
            } else {
                cell?.downvoteButton.isSelected = false
            }
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if state == .journal {
            let vc = UserDreamViewController(title: viewModel.journals[(indexPath as NSIndexPath).row].title, author: viewModel.journals[(indexPath as NSIndexPath).row].author, text: viewModel.journals[(indexPath as NSIndexPath).row].text, id: viewModel.journals[(indexPath as NSIndexPath).row].id)
            present(vc, animated: true, completion: nil)
        } else {
            let vc = UserDreamViewController(title: viewModel.starred[(indexPath as NSIndexPath).row].title, author: viewModel.starred[(indexPath as NSIndexPath).row].author, text: viewModel.starred[(indexPath as NSIndexPath).row].text, id: viewModel.starred[(indexPath as NSIndexPath).row].id)
            present(vc, animated: true, completion: nil)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profile-header", for: indexPath) as! UserProfileHeaderView
            
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
        present(pickerVC, animated: true, completion: nil)
    }
    
    // Header delegate
    func profileImageTapped() {
        presentProfileImagePicker()
    }
    
    func journalTabSelected() {
        state = .journal
        collectionView?.reloadData()
    }
    
    func starredTabSelected() {
        state = .starred
        collectionView?.reloadData()
    }
    
    func settingsSelected() {
        let settingsVC = UserSettingViewController()
        present(settingsVC, animated: true, completion: nil)
    }
    
    func shareTapped(_ title: String, author: String, text: String, id: String, date: String) {
        viewModel.shareTitle = title
        viewModel.shareAuthor = author
        viewModel.shareText = text
        viewModel.shareId = id
        viewModel.shareDate = date
        
        if state == .journal {
            let actionSheet = UIActionSheet(title: "Share to", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil, otherButtonTitles: "Dreamscape", "Twitter", "Facebook")
            actionSheet.show(in: view)
        } else {
            let actionSheet = UIActionSheet(title: "Share to", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil,otherButtonTitles: "Twitter", "Facebook")
            actionSheet.show(in: view)
        }
    }
    
    func dataDidLoad() {
        collectionView?.reloadData()
        self.headerDelegate?.numberOfItemsInSection(self.viewModel.journals.count, starred: viewModel.starred.count)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if state == .journal {
            switch buttonIndex {
            case 0:
                print(")")
            case 1:
                let dreamDictionary = ["title":viewModel.shareTitle, "author":viewModel.shareAuthor, "text":viewModel.shareText, "date":viewModel.shareDate, "upvotes":0, "downvotes":0] as [String : Any]
                
                FIRDatabase.database().reference().child("/feed").child("\(viewModel.shareId)").setValue(dreamDictionary)
            case 2:
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                    self.present(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case 3:
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                    self.present(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        } else {
            switch buttonIndex {
            case 0:
                print(")")
            case 1:
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText("Share on Twitter")
                    self.present(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case 2:
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    twitterSheet.setInitialText("Share on Facebook")
                    self.present(twitterSheet, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }
}

protocol UserProfileDelegate: class {
    func numberOfItemsInSection(_ journals: Int, starred: Int)
}
