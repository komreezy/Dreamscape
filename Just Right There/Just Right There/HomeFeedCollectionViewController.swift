//
//  HomeFeedCollectionViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import Social
import MessageUI

private let homeFeedReuseIdentifier = "homeFeedCell"

class HomeFeedCollectionViewController: UICollectionViewController,
HomeFeedViewModelDelegate,
HomeFeedCellDelegate,
UserProfileViewModelDelegate,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate {

    var viewModel: HomeFeedViewModel
    var userDefaults: UserDefaults
    var refreshControl: UIRefreshControl
    var hud: MBProgressHUD?
    
    let alphabet = ["a","b","c","d","e","f","g",
                    "h","i","j","k","l","m","n",
                    "o","p","q","r","s","t","u",
                    "v","w","x","y","z",]
    
    init(homeFeedViewModel: HomeFeedViewModel) {
        viewModel = homeFeedViewModel
        
        userDefaults = UserDefaults.standard
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.white
        
        super.init(collectionViewLayout: HomeFeedCollectionViewController.provideCollectionViewLayout())
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .indeterminate
        hud?.label.text = "Loading"
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        viewModel.delegate = self
        refreshControl.addTarget(self, action: #selector(HomeFeedCollectionViewController.refresh), for: .valueChanged)
        
        collectionView!.addSubview(refreshControl)
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
        logoImageView.text = "dreamscape".uppercased()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.white
        logoImageView.textAlignment = .center
        
        navigationItem.titleView = logoImageView
        
        let loadingTimer = Timer.scheduledTimer(timeInterval: 4.0,
                                                target: self,
                                                selector: #selector(HomeFeedCollectionViewController.loadingTimeout),
                                                userInfo: nil,
                                                repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "user") == false {
            let vc = ContainerNavigationController(rootViewController: LandingPageViewController())
            vc.isNavigationBarHidden = true
            vc.navigationBar.barTintColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            present(vc, animated: true, completion: nil)
        }
        
        if let collectionView = collectionView {
            viewModel.requestStarredData()
            viewModel.requestDownvotesData()
            collectionView.reloadData()
        }
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
        return viewModel.dreamDictionary.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! HomeFeedImageCollectionViewCell
        
        cell.delegate = self
        cell.dream = viewModel.dreamDictionary[(indexPath as NSIndexPath).row]
        
        let letter: String = viewModel.dreamDictionary[(indexPath as NSIndexPath).row].author[0..<1]
            let index = alphabet.index(of: letter.lowercased())
        
            if index == 0 || index == 14 {
                cell.imageView.setImage(UIImage(named: "alien-head"), for: UIControlState())
            } else if index == 1 || index == 14 {
                cell.imageView.setImage(UIImage(named: "atom"), for: UIControlState())
            } else if index == 2 || index == 15 {
                cell.imageView.setImage(UIImage(named: "brain"), for: UIControlState())
            } else if index == 3 || index == 16 {
                cell.imageView.setImage(UIImage(named: "circus-camel"), for: UIControlState())
            } else if index == 4 || index == 17 {
                cell.imageView.setImage(UIImage(named: "cloud-and-moon"), for: UIControlState())
            } else if index == 5 || index == 18 {
                cell.imageView.setImage(UIImage(named: "earth-globe"), for: UIControlState())
            } else if index == 6 || index == 19 {
                cell.imageView.setImage(UIImage(named: "fire-gear"), for: UIControlState())
            } else if index == 7 || index == 20 {
                cell.imageView.setImage(UIImage(named: "flask"), for: UIControlState())
            } else if index == 8 || index == 21 {
                cell.imageView.setImage(UIImage(named: "giraffe"), for: UIControlState())
            } else if index == 9 || index == 22 {
                cell.imageView.setImage(UIImage(named: "hot-air-balloon"), for: UIControlState())
            } else if index == 10 || index == 23 {
                cell.imageView.setImage(UIImage(named: "islamic-art-1"), for: UIControlState())
            } else if index == 11 || index == 24 {
                cell.imageView.setImage(UIImage(named: "islamic-art-2"), for: UIControlState())
            } else if index == 12 || index == 25 {
                cell.imageView.setImage(UIImage(named: "oil-lamp"), for: UIControlState())
            } else if index == 13 || index == 26 {
                cell.imageView.setImage(UIImage(named: "saturn"), for: UIControlState())
            }
        
            if starredIds.contains(cell.id!) {
                cell.upvoteButton.isSelected = true
            } else {
                cell.upvoteButton.isSelected = false
            }
        
            if downvoteIds.contains(cell.id!) {
                cell.downvoteButton.isSelected = true
            } else {
                cell.downvoteButton.isSelected = false
            }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let dreamViewController = DreamReaderViewController(dream: viewModel.dreamDictionary[(indexPath as NSIndexPath).row])
        navigationController?.pushViewController(dreamViewController, animated: true)
    }
    
    func addButtonTapped() {
        let hasAgreedToRules = UserDefaults.standard.bool(forKey: "agreed")
        
        if hasAgreedToRules {
            let addDreamViewController = NewDreamViewController()
            present(addDreamViewController, animated: true, completion: nil)
        } else {
            let agreeViewController = AgreeRulesViewController()
            present(agreeViewController, animated: true, completion: nil)
        }
    }
    
    func dataDidLoad() {
        collectionView?.reloadSections(IndexSet(integer: 0))
        hud?.hide(animated: true)
        //loadingLabel.hidden = true
    }
    
    func refresh() {
        viewModel.requestData()
        collectionView?.reloadSections(IndexSet(integer: 0))
        refreshControl.endRefreshing()
    }
    
    func loadingTimeout() {
        hud?.label.text = "Check Internet Connection"
    }
    
    // MARK: HomeFeedCellDelegate
    func starTapped() {
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    func shareTapped(_ title: String, author: String, text: String, id: String, date: String) {
        viewModel.shareTitle = title
        viewModel.shareAuthor = author
        viewModel.shareText = text
        viewModel.shareId = id
        viewModel.shareDate = date
        
        let actionSheet = UIActionSheet(title: "Options", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil, otherButtonTitles: "Share to Twitter", "Share to Facebook", "Report")
        actionSheet.show(in: view)
    }
    
    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    func launchEmail(_ sender: AnyObject) {
        let emailTitle = "Reason For Report"
        let messageBody = ""
        let toRecipents = ["dreamscape9817234@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .coverVertical
        present(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print(")")
        case 1:
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                self.present(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts",
                                              message: "Please login to a Twitter account to share.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 2:
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                twitterSheet.setInitialText("\(viewModel.shareTitle) by \(viewModel.shareAuthor)\n\n\(viewModel.shareText)")
                self.present(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts",
                                              message: "Please login to a Facebook account to share.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 3:
            if MFMailComposeViewController.canSendMail() {
                launchEmail(self)
            } else {
                let alert = UIAlertController(title: "Unable To Report",
                                              message: "Please set up mail client before reporting.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }

    subscript (r: CountableClosedRange<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[(start ... end)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[(start ..< end)]
    }
}
