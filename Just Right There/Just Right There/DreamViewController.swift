//
//  DreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase

class DreamViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {

    var scrollView: UIScrollView
    var headerView: UIView
    var dreamTitle: UILabel
    var authorLabel: UILabel
    var dreamTextView: UITextView
    var saveButton: UIButton
    var topDividerView: UIView
    var bottomDividerView: UIView
    var dateLabel: UILabel
    var profileImageView: UIImageView
    var upvoteButton: SpringButton
    var downvoteButton: SpringButton
    var starLabel: SpringLabel
    var shareButton: UIButton
    var dream: Dream
    var karma: Int = 0 {
        didSet {
            starLabel.text = "\(self.karma)"
        }
    }
    
    var currentTitle: String
    var currentAuthor: String
    var currentText: String
    var currentId: String
    
    var id: String?
    var currentState: DreamState
    
    enum DreamState {
        case Delete
        case Save
    }
    
    init(dream: Dream) {
        self.dream = dream
        currentTitle = dream.title
        currentAuthor = dream.author
        currentText = dream.text
        currentId = dream.id
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 10.5)
        shareButton.backgroundColor = UIColor.clearColor()
        shareButton.layer.cornerRadius = 4.0
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        shareButton.setTitle("share".uppercaseString, forState: .Normal)
        shareButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Normal)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        topDividerView = UIView()
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.12)
        
        bottomDividerView = UIView()
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.12)
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Montserrat", size: 22.0)
        dreamTitle.textColor = UIColor.whiteColor()
        dreamTitle.textAlignment = .Left
        dreamTitle.numberOfLines = 3
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Montserrat", size: 14.0)
        authorLabel.textColor = UIColor.whiteColor()
        authorLabel.text = "by \(currentAuthor)"
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.text = dream.date
        dateLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.54)
        
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 18.0
        profileImageView.backgroundColor = UIColor.primaryPurple()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        dreamTextView = UITextView()
        dreamTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamTextView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        dreamTextView.showsVerticalScrollIndicator = false
        dreamTextView.scrollEnabled = false
        dreamTextView.attributedText = NSAttributedString(string: currentText, attributes: attributes)
        dreamTextView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Delete", forState: .Normal)
        saveButton.setTitleColor(WhiteColor, forState: .Normal)
        saveButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        upvoteButton = SpringButton()
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.setImage(UIImage(named: "upvote"), forState: .Normal)
        upvoteButton.setImage(UIImage(named: "upvote-highlighted"), forState: .Selected)
        upvoteButton.animation = "pop"
        
        downvoteButton = SpringButton()
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.setImage(UIImage(named: "downvote"), forState: .Normal)
        downvoteButton.setImage(UIImage(named: "downvote-highlighted"), forState: .Selected)
        downvoteButton.animation = "pop"
        
        starLabel = SpringLabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .Center
        starLabel.animation = "squeeze"
        starLabel.duration = 0.5
        
        currentState = .Delete
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        saveButton.addTarget(self, action: #selector(DreamViewController.saveTapped), forControlEvents: .TouchUpInside)
        upvoteButton.addTarget(self, action: #selector(DreamViewController.upvoteTapped), forControlEvents: .TouchUpInside)
        downvoteButton.addTarget(self, action: #selector(DreamViewController.downvoteTapped), forControlEvents: .TouchUpInside)
        dreamTextView.delegate = self
        
        headerView.addSubview(dreamTitle)
        headerView.addSubview(authorLabel)
        headerView.addSubview(profileImageView)
        headerView.addSubview(dateLabel)
        headerView.addSubview(starLabel)
        headerView.addSubview(upvoteButton)
        headerView.addSubview(downvoteButton)
        headerView.addSubview(saveButton)
        headerView.addSubview(topDividerView)
        headerView.addSubview(bottomDividerView)
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(dreamTextView)
        
        view.addSubview(scrollView)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
            if currentAuthor == username {
                dreamTextView.editable = true
            } else {
                dreamTextView.editable = false
                
                saveButton.userInteractionEnabled = false
                saveButton.alpha = 0
            }
        }
        
        let reportFlag = UIButton()
        reportFlag.frame = CGRectMake(0, 0, 30, 30)
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(13.0, 5.0, 13.0, 5.0)
        reportFlag.setImage(UIImage(named: "more"), forState: .Normal)
        reportFlag.addTarget(self, action: #selector(DreamViewController.flagTapped), forControlEvents: .TouchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: reportFlag)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = headerView.bounds.height + dreamTextView.bounds.height + 10
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, height)
    }
    
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        currentState = .Save
        saveButton.setTitle("Save", forState: .Normal)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        currentState = .Delete
        saveButton.setTitle("Delete", forState: .Normal)
    }
    
    func upvoteTapped() {
        if upvoteButton.selected {
            upvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id {
                starLabel.text = "\(karma - 1)"
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(dream.upvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
            }
        } else {
            upvoteButton.selected = true
            downvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id {
                if !starredIds.contains(id) {
                    starLabel.text = "\(self.karma + 1)"
                    starLabel.animate()
                    
                    if let title = dreamTitle.text,
                        let author = authorLabel.text,
                        let text = dreamTextView.text,
                        let date = dateLabel.text {
                        
                        let dreamDictionary = [
                            "title":title,
                            "author":author,
                            "text":text,
                            "date":"\(date)",
                            "upvotes":"\(dream.upvotes + 1)",
                            "downvote":"\(dream.downvotes)"
                        ]
                        
                        FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(dream.upvotes + 1)
                        FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").setValue(dreamDictionary)
                    }
                }
            }
        }
    }
    
    func downvoteTapped() {
        if downvoteButton.selected {
            downvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id {
                upvoteButton.selected = false
                starLabel.text = "\(karma - 1)"
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(dream.downvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
            }
        } else {
            downvoteButton.selected = true
            upvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id {
                upvoteButton.selected = false
                starLabel.text = "\(karma + 1)"
                starLabel.animate()
                
                if let title = dreamTitle.text,
                    let author = authorLabel.text,
                    let text = dreamTextView.text,
                    let date = dateLabel.text {
                    
                    let dreamDictionary = [
                        "title":title,
                        "author":author,
                        "text":text,
                        "date":"\(date)",
                        "upvotes":"\(dream.upvotes)",
                        "downvote":"\(dream.downvotes)"
                    ]
                    
                    FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(dream.downvotes + 1)
                    FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").setValue(dreamDictionary)
                }
            }
        }
    }
    
    func saveTapped() {
        if currentState == .Save {
            if dreamTextView.text?.isEmpty == false {
                if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                    FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)/text").setValue(dreamTextView.text)
                }
            }
        } else {
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)").removeValue()
                FIRDatabase.database().reference().child("/feed/\(currentId)").removeValue()
            }
            
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "journals")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func flagTapped() {
        FIRDatabase.database().reference().child("/reported/\(currentAuthor)").setValue(true)
        
        if MFMailComposeViewController.canSendMail() {
            launchEmail(self)
        } else {
            let alert = UIAlertController(title: "Unable To Report", message: "Please set up mail client before reporting.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    func launchEmail(sender: AnyObject) {
        let emailTitle = "Reason For Report"
        let messageBody = ""
        let toRecipents = ["dreamscape9817234@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .CoverVertical
        presentViewController(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            headerView.al_top == scrollView.al_top,
            headerView.al_left == scrollView.al_left,
            headerView.al_right == scrollView.al_right,
            headerView.al_height == UIScreen.mainScreen().bounds.height * 0.25,
            
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_top == headerView.al_top + 30,
            dreamTitle.al_left == view.al_left + 20,
            dreamTitle.al_right == view.al_right - 35,
            
            authorLabel.al_left == profileImageView.al_right + 12,
            authorLabel.al_bottom == profileImageView.al_centerY,
            
            dateLabel.al_left == authorLabel.al_left,
            dateLabel.al_top == authorLabel.al_bottom + 2,
            
            dreamTextView.al_left == scrollView.al_left + 20,
            dreamTextView.al_bottom == scrollView.al_bottom,
            dreamTextView.al_right == scrollView.al_right - 20,
            dreamTextView.al_top == bottomDividerView.al_bottom + 12,
            
            profileImageView.al_left == headerView.al_left + 24,
            profileImageView.al_centerY == bottomDividerView.al_top - UIScreen.mainScreen().bounds.height * 0.07,
            profileImageView.al_height == 36,
            profileImageView.al_width == 36,
            
            saveButton.al_right == view.al_right - 15,
            saveButton.al_centerY == headerView.al_centerY - 5,
            saveButton.al_width == 55,
            saveButton.al_height == 35,
            
            scrollView.al_bottom == view.al_bottom,
            scrollView.al_top == view.al_top,
            scrollView.al_left == view.al_left,
            scrollView.al_right == view.al_right,
            
            topDividerView.al_left == view.al_left + 24,
            topDividerView.al_right == view.al_right - 24,
            topDividerView.al_top == dreamTitle.al_bottom + 24,
            topDividerView.al_height == 1,
            
            bottomDividerView.al_left == view.al_left + 24,
            bottomDividerView.al_right == view.al_right - 24,
            bottomDividerView.al_top == headerView.al_bottom,
            bottomDividerView.al_height == 1
        ])
        
        view.addConstraints([
            downvoteButton.al_right == headerView.al_right - 24,
            downvoteButton.al_centerY == dreamTitle.al_centerY,
            downvoteButton.al_height == 24,
            downvoteButton.al_width == 24,
            
            upvoteButton.al_right == downvoteButton.al_left - 12,
            upvoteButton.al_centerY == dreamTitle.al_centerY,
            upvoteButton.al_height == 24,
            upvoteButton.al_width == 24,
            
            starLabel.al_centerY == upvoteButton.al_centerY,
            starLabel.al_right == upvoteButton.al_left - 12
        ])
    }
}
