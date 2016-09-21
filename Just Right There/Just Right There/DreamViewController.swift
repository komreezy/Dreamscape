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
    var dividerView: UIView
    var starButton: SpringButton
    var starLabel: SpringLabel
    
    var currentTitle: String
    var currentAuthor: String
    var currentText: String
    var currentId: String
    
    var id: String?
    var stars: Int? {
        didSet {
            if self.stars != nil {
                starLabel.text = "\(self.stars!)"
            } else {
                starLabel.text = "0"
            }
        }
    }
    
    var currentState: DreamState
    
    enum DreamState {
        case Delete
        case Save
    }
    
    init(title: String, author: String, text: String, id: String) {
        currentTitle = title
        currentAuthor = author
        currentText = text
        currentId = id
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.lightBlueGrey()
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.whiteColor()
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Avenir", size: 22.0)
        dreamTitle.textColor = UIColor.blackColor()
        dreamTitle.textAlignment = .Left
        dreamTitle.numberOfLines = 3
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "OpenSans", size: 14.0)
        authorLabel.textColor = UIColor.flatGrey()
        authorLabel.textAlignment = .Left
        authorLabel.text = "by \(currentAuthor)"
        
        dreamTextView = UITextView()
        dreamTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamTextView.backgroundColor = UIColor.whiteColor()
        dreamTextView.font = UIFont(name: "OpenSans", size: 17.0)
        dreamTextView.showsVerticalScrollIndicator = false
        dreamTextView.scrollEnabled = false
        dreamTextView.text = currentText
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Delete", forState: .Normal)
        saveButton.setTitleColor(WhiteColor, forState: .Normal)
        saveButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        starButton = SpringButton()
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.setImage(UIImage(named: "greystar"), forState: .Normal)
        starButton.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        starButton.animation = "pop"
        
        starLabel = SpringLabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.text = "\(12)"
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .Center
        starLabel.animation = "squeeze"
        starLabel.duration = 0.5
        
        currentState = .Delete
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.whiteColor()
        
        saveButton.addTarget(self, action: #selector(DreamViewController.saveTapped), forControlEvents: .TouchUpInside)
        //starButton.addTarget(self, action: #selector(DreamViewController.starTapped), forControlEvents: .TouchUpInside)
        dreamTextView.delegate = self
        
        headerView.addSubview(dreamTitle)
        headerView.addSubview(authorLabel)
        headerView.addSubview(saveButton)
        headerView.addSubview(starLabel)
        headerView.addSubview(starButton)
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(dividerView)
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
        reportFlag.translatesAutoresizingMaskIntoConstraints = false
        reportFlag.setImage(UIImage(named: "flag"), forState: .Normal)
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
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
    
    func starTapped() {
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"), let id = id, let stars = stars {
            //let feedRef = rootRef.childByAppendingPath("feed/\(id)/stars")
            //let userRef = rootRef.childByAppendingPath("/users/\(username)/starred/\(id)")
            
            if !starredIds.contains(id) {
                starButton.animate()
                starButton.setImage(UIImage(named: "goldstar"), forState: .Normal)
                starLabel.text = "\(stars + 1)"
                starLabel.textColor = UIColor.flatGold()
                starLabel.animate()
                
                if let title = dreamTitle.text,
                    let author = authorLabel.text,
                    let text = dreamTextView.text {
                    let dreamDictionary = ["title":title, "author":author, "text":text, "stars":stars + 1]
                    FIRDatabase.database().reference().child("feed/\(id)/stars").setValue(stars + 1)
                    FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").setValue(dreamDictionary)
                    
                }
            } else {
                starButton.animate()
                starButton.setImage(UIImage(named: "greystar"), forState: .Normal)
                starLabel.text = "\(stars - 1)"
                starLabel.textColor = UIColor.grayColor()
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/stars").setValue(stars - 1)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
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
            headerView.al_height == 180,
            
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_centerY == headerView.al_centerY - 7,
            dreamTitle.al_left == view.al_left + 20,
            dreamTitle.al_right == view.al_right - 35,
            
            authorLabel.al_left == dreamTitle.al_left,
            authorLabel.al_top == dreamTitle.al_bottom + 4,
            
            dreamTextView.al_left == scrollView.al_left + 20,
            dreamTextView.al_bottom == scrollView.al_bottom,
            dreamTextView.al_right == scrollView.al_right - 20,
            dreamTextView.al_top == dividerView.al_bottom,
            
            saveButton.al_right == view.al_right - 15,
            saveButton.al_centerY == headerView.al_centerY - 5,
            saveButton.al_width == 55,
            saveButton.al_height == 35,
            
            scrollView.al_bottom == view.al_bottom,
            scrollView.al_top == view.al_top,
            scrollView.al_left == view.al_left,
            scrollView.al_right == view.al_right,
            
            dividerView.al_left == view.al_left,
            dividerView.al_right == view.al_right,
            dividerView.al_top == headerView.al_bottom,
            dividerView.al_height == 7,
            
            starButton.al_centerX == headerView.al_right - 30,
            starButton.al_height == 30,
            starButton.al_width == 30,
            starButton.al_centerY == dreamTitle.al_centerY,
            
            starLabel.al_centerX == starButton.al_centerX,
            starLabel.al_top == starButton.al_bottom
        ])
    }
}
