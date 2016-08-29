//
//  NewDreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

var saveText: String = ""

class NewDreamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    enum TabState {
        case Share
        case Keep
    }
    
    var state: TabState
    
    var navigationBar: UIView
    var textView: UITextView
    var cancelButton: UIButton
    var sendButton: UIButton
    
    var containerTabBar: UIView
    var shareLabel: UILabel
    var keepLabel: UILabel
    var dreamTitleLabel: UITextField
    var dateLabel: UILabel
    var borderLine: UIView
    var highlightLine: UIView
    var textViewSeparatorView: UIView
    
    var shareTapRecognizer: UITapGestureRecognizer?
    var keepTapRecognizer: UITapGestureRecognizer?
    
    var highlightLeftConstraint: NSLayoutConstraint?
    var highlightRightConstraint: NSLayoutConstraint?
    var textViewHeightConstraint: NSLayoutConstraint?
    var textViewBottomConstraint: NSLayoutConstraint?
    
    var dateFormatter: NSDateFormatter
    var now: NSDate?
    var nowString: String?
    
    var keyboardHeight: CGFloat?
    
    weak var delegate: NewDreamViewControllerAnimatable?
    
    init() {
        
        state = .Keep
        
        navigationBar = UIView()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor.navyColor()
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "OpenSans", size: 16.0)
        textView.text = "Type your Dream here.."
        textView.textColor = UIColor.lightGrayColor()
        textView.selectable = true
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(30.0, 15.0, 15.0, 30.0)
        
        sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Done", forState: .Normal)
        sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        containerTabBar = UIView()
        containerTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        shareLabel = UILabel()
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        shareLabel.text = "SHARE"
        shareLabel.textAlignment = .Center
        shareLabel.textColor = UIColor.lightGreyBlue()
        shareLabel.userInteractionEnabled = true
        
        keepLabel = UILabel()
        keepLabel.translatesAutoresizingMaskIntoConstraints = false
        keepLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        keepLabel.text = "KEEP"
        keepLabel.textAlignment = .Center
        keepLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.userInteractionEnabled = true
        
        borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.grayColor()
        
        highlightLine = UIView()
        highlightLine.translatesAutoresizingMaskIntoConstraints = false
        highlightLine.backgroundColor = UIColor.navyColor()
        
        dreamTitleLabel = UITextField()
        dreamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamTitleLabel.font = UIFont(name: "HelveticaNeue", size: 24.0)
        dreamTitleLabel.placeholder = "Enter Dream Title"
        dreamTitleLabel.textAlignment = .Center
        dreamTitleLabel.textColor = BlackColor
        dreamTitleLabel.returnKeyType = .Done
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.grayColor()
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        dateLabel.textAlignment = .Center

        textViewSeparatorView = UIView()
        textViewSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        textViewSeparatorView.backgroundColor = UIColor.navyColor()
        
        dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .FullStyle
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a zz"
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.whiteColor()
        
        shareTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.shareTapped))
        keepTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.keepTapped))
        shareLabel.addGestureRecognizer(shareTapRecognizer!)
        keepLabel.addGestureRecognizer(keepTapRecognizer!)
        
        cancelButton.addTarget(self, action: #selector(NewDreamViewController.cancelTapped), forControlEvents: .TouchUpInside)
        sendButton.addTarget(self, action: #selector(NewDreamViewController.sendTapped), forControlEvents: .TouchUpInside)
        
        dreamTitleLabel.delegate = self
        textView.delegate = self
        
        view.addSubview(navigationBar)
        
        containerTabBar.addSubview(shareLabel)
        containerTabBar.addSubview(keepLabel)
        containerTabBar.addSubview(borderLine)
        containerTabBar.addSubview(highlightLine)
        view.addSubview(containerTabBar)
        
        view.addSubview(dreamTitleLabel)
        view.addSubview(dateLabel)
        
        navigationBar.addSubview(cancelButton)
        navigationBar.addSubview(sendButton)
        view.addSubview(navigationBar)
        view.addSubview(textView)
        view.addSubview(textViewSeparatorView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewDreamViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        now = NSDate()
        nowString = dateFormatter.stringFromDate(now!)
        dateLabel.text = nowString
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let hasSeenToolTip = NSUserDefaults.standardUserDefaults().boolForKey("newdreamtooltip")
        
        if hasSeenToolTip {
            // coolio
        } else {
            // show tip
            let alert = UIAlertController(title: "Important!!!", message: "Before you press the done button on your dream, make sure you select the correct tab to \"Share\" it or just \"Keep\" it in your journal!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "newdreamtooltip")
        }
        
        if saveText != "" {
            textView.text = saveText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textView.resignFirstResponder()
        dreamTitleLabel.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = BlackColor
        }
        
        if let keyboardHeight = keyboardHeight {
            textViewBottomConstraint?.constant = -keyboardHeight
            
            UIView.animateWithDuration(0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your Dream here.."
            textView.textColor = UIColor.lightGrayColor()
        } else {
            saveText = textView.text
        }
        
        textViewBottomConstraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        keyboardHeight = frame.height
    }
    
    func shareTapped() {
        shareLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.textColor = UIColor.lightGreyBlue()
        state = .Share
        
        highlightLeftConstraint?.constant = -containerTabBar.bounds.width / 2
        highlightRightConstraint?.constant = -containerTabBar.bounds.width / 2
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keepTapped() {
        shareLabel.textColor = UIColor.lightGreyBlue()
        keepLabel.textColor = UIColor.navyColor()
        state = .Keep
        
        highlightLeftConstraint?.constant = 0.0
        highlightRightConstraint?.constant = 0.0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func cancelTapped() {
        saveText = ""
        delegate?.shouldLeaveNewDreamViewController(0)
    }
    
    func sendTapped() {
        if dreamTitleLabel.text?.isEmpty == false && textView.text != "Type your Dream here.." {
            if state == .Keep {
                if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                        let dreamDictionary = ["title":dreamTitleLabel.text!, "author":"\(username)", "text":textView.text, "date":"\(nowString!)", "stars":0]
                        let userRef = rootRef.childByAppendingPath("/users/\(username)/journals")
                        let userPostRef = userRef.childByAutoId()
                        userPostRef.setValue(dreamDictionary)
                    
                    if let journals = NSUserDefaults.standardUserDefaults().objectForKey("journals") as? [[String:AnyObject]] {
                        var journalsCopy = NSMutableArray(array: journals)
                        journalsCopy.addObject(dreamDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(journalsCopy, forKey: "journals")
                    } else {
                        let newJournalsArray = [dreamDictionary]
                        NSUserDefaults.standardUserDefaults().setObject(newJournalsArray, forKey: "journals")
                    }
                }
            } else if state == .Share {
                if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                    let dreamDictionary = ["title":dreamTitleLabel.text!, "author":"\(username)", "text":textView.text, "date":"\(nowString!)", "stars":0]
                    let feedRef = rootRef.childByAppendingPath("/feed")
                    let newPostRef: Firebase = feedRef.childByAutoId()
                    let userRef = rootRef.childByAppendingPath("/users/\(username)/journals")
                    let userPostRef = userRef.childByAutoId()
                    
                    userPostRef.setValue(dreamDictionary)
                    newPostRef.setValue(dreamDictionary)
                }
            }
            saveText = ""
            textView.text = ""
            dreamTitleLabel.text = ""
            delegate?.shouldLeaveNewDreamViewController(2)
        } else if dreamTitleLabel.text?.isEmpty == true {
            if state == .Keep {
                let alert = UIAlertController(title: "Don't Forget A Title!", message: "Before you save that dream of yours, make sure you give it name.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Don't Forget A Title!", message: "Before you share that masterpiece, give your work a title.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else if textView.text == "Type your Dream here.." {
            let alert = UIAlertController(title: "Whoops!", message: "No dream to upload. Type your dream in the text view below.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setupLayout() {
        
        highlightLeftConstraint = highlightLine.al_left == containerTabBar.al_centerX
        highlightRightConstraint = highlightLine.al_right == containerTabBar.al_right
        textViewBottomConstraint = textView.al_bottom == view.al_bottom
        
        view.addConstraints([
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_top == view.al_top,
            navigationBar.al_height == 50,
            
            cancelButton.al_left == navigationBar.al_left,
            cancelButton.al_centerY == navigationBar.al_centerY - 5,
            cancelButton.al_width == 60,
            cancelButton.al_height == 60,
            
            sendButton.al_right == navigationBar.al_right - 15,
            sendButton.al_centerY == navigationBar.al_centerY,
            
            textView.al_top == navigationBar.al_bottom + 155,
            textViewBottomConstraint!,
            textView.al_left == view.al_left + 5,
            textView.al_right == view.al_right - 5,
            
            containerTabBar.al_left == view.al_left,
            containerTabBar.al_right == view.al_right,
            containerTabBar.al_top == navigationBar.al_bottom,
            containerTabBar.al_height == 50,
            
            shareLabel.al_left == containerTabBar.al_left,
            shareLabel.al_right == containerTabBar.al_centerX,
            shareLabel.al_bottom == containerTabBar.al_bottom,
            shareLabel.al_top == containerTabBar.al_top,
            
            keepLabel.al_top == containerTabBar.al_top,
            keepLabel.al_bottom == containerTabBar.al_bottom,
            keepLabel.al_left == containerTabBar.al_centerX,
            keepLabel.al_right == containerTabBar.al_right,
            
            dreamTitleLabel.al_centerX == view.al_centerX,
            dreamTitleLabel.al_top == containerTabBar.al_bottom + 25,
            dreamTitleLabel.al_left == view.al_left,
            dreamTitleLabel.al_right == view.al_right,
            
            dateLabel.al_left == dreamTitleLabel.al_left,
            dateLabel.al_right == dreamTitleLabel.al_right,
            dateLabel.al_centerX == view.al_centerX,
            dateLabel.al_top == dreamTitleLabel.al_bottom + 5
        ])
        
        view.addConstraints([
            borderLine.al_height == 1.0,
            borderLine.al_left == containerTabBar.al_left,
            borderLine.al_right == containerTabBar.al_right,
            borderLine.al_bottom == containerTabBar.al_bottom,
            
            highlightLine.al_height == 4.0,
            highlightLeftConstraint!,
            highlightRightConstraint!,
            highlightLine.al_bottom == containerTabBar.al_bottom,
            
            textViewSeparatorView.al_height == 2.0,
            textViewSeparatorView.al_left == view.al_left,
            textViewSeparatorView.al_right == view.al_right,
            textViewSeparatorView.al_bottom == textView.al_top - 2
        ])
    }
}

protocol NewDreamViewControllerAnimatable: class {
    func shouldLeaveNewDreamViewController(index: Int)
}
