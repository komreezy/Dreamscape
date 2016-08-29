//
//  DreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import MessageUI

class DreamViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {

    var headerView: UIView
    var dismissButton: UIButton
    var dreamTitle: UILabel
    var authorLabel: UILabel
    var dreamTextView: UITextView
    var reportFlag: UIButton
    var saveButton: UIButton
    
    var currentTitle: String
    var currentAuthor: String
    var currentText: String
    var currentId: String
    
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
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.navyColor()
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(UIImage(named: "close"), forState: .Normal)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(11.0, 11.0, 11.0, 11.0)
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Roboto", size: 20.0)
        dreamTitle.textColor = UIColor.whiteColor()
        dreamTitle.textAlignment = .Center
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "OpenSans", size: 14.0)
        authorLabel.textColor = UIColor.whiteColor()
        dreamTitle.textAlignment = .Center
        authorLabel.text = "by \(currentAuthor)"
        
        dreamTextView = UITextView()
        dreamTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamTextView.backgroundColor = UIColor.whiteColor()
        dreamTextView.font = UIFont(name: "OpenSans", size: 17.0)
        dreamTextView.showsVerticalScrollIndicator = false
        dreamTextView.text = currentText
        
        reportFlag = UIButton()
        reportFlag.translatesAutoresizingMaskIntoConstraints = false
        reportFlag.setImage(UIImage(named: "flag"), forState: .Normal)
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Delete", forState: .Normal)
        saveButton.setTitleColor(WhiteColor, forState: .Normal)
        saveButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        currentState = .Delete
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.whiteColor()
        
        dismissButton.addTarget(self, action: #selector(DreamViewController.dismissViewController), forControlEvents: .TouchUpInside)
        reportFlag.addTarget(self, action: #selector(DreamViewController.flagTapped), forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: #selector(DreamViewController.saveTapped), forControlEvents: .TouchUpInside)
        dreamTextView.delegate = self
        
        headerView.addSubview(dreamTitle)
        headerView.addSubview(authorLabel)
        headerView.addSubview(dismissButton)
        headerView.addSubview(reportFlag)
        headerView.addSubview(saveButton)
        view.addSubview(headerView)
        view.addSubview(dreamTextView)
        
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
                
                reportFlag.userInteractionEnabled = false
                reportFlag.alpha = 0
            } else {
                dreamTextView.editable = false
                
                reportFlag.userInteractionEnabled = true
                reportFlag.alpha = 1
                
                saveButton.userInteractionEnabled = false
                saveButton.alpha = 0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func flagTapped() {
        let reportRef = rootRef.childByAppendingPath("/reported/\(currentAuthor)")
        reportRef.setValue(true)
        
        if MFMailComposeViewController.canSendMail() {
            launchEmail(self)
        } else {
            let alert = UIAlertController(title: "Unable To Report", message: "Please set up mail client before reporting.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        currentState = .Save
        saveButton.setTitle("Save", forState: .Normal)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        currentState = .Delete
        saveButton.setTitle("Delete", forState: .Normal)
    }
    
    func saveTapped() {
        if currentState == .Save {
            if dreamTextView.text?.isEmpty == false {
                if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                    let userRef = rootRef.childByAppendingPath("/users/\(username)/journals/\(currentId)/text")
                    userRef.setValue(dreamTextView.text)
                }
            }
        } else {
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                let userRef = rootRef.childByAppendingPath("/users/\(username)/journals/\(currentId)")
                userRef.removeValue()
            }
            
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "journals")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
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
            headerView.al_top == view.al_top,
            headerView.al_left == view.al_left,
            headerView.al_right == view.al_right,
            headerView.al_height == 105,
            
            dismissButton.al_left == headerView.al_left + 5,
            dismissButton.al_centerY == dreamTitle.al_centerY,
            dismissButton.al_height == 35,
            dismissButton.al_width == 35,
            
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_centerY == headerView.al_centerY - 7,
            dreamTitle.al_left == dismissButton.al_right,
            dreamTitle.al_right == reportFlag.al_left,
            
            authorLabel.al_centerX == dreamTitle.al_centerX,
            authorLabel.al_top == dreamTitle.al_bottom + 4,
            
            dreamTextView.al_left == view.al_left + 20,
            dreamTextView.al_bottom == view.al_bottom,
            dreamTextView.al_right == view.al_right - 20,
            dreamTextView.al_top == headerView.al_bottom,
            
            reportFlag.al_right == view.al_right - 12,
            reportFlag.al_centerY == headerView.al_centerY - 3,
            reportFlag.al_width == 27,
            reportFlag.al_height == 31.5,
            
            saveButton.al_right == view.al_right - 15,
            saveButton.al_centerY == headerView.al_centerY - 5,
            saveButton.al_width == 55,
            saveButton.al_height == 35
        ])
    }
}
