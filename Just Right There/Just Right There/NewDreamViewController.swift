//
//  NewDreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase

var saveText: String = ""

class NewDreamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ComposeAccessoryViewDelegate {

    enum TabState {
        case Share
        case Keep
    }
    
    var state: TabState
    var textView: UITextView
    var shareLabel: UILabel
    var keepLabel: UILabel
    var dreamTitleLabel: UITextField
    var dateLabel: UILabel
    var borderLine: UIView
    var highlightLine: UIView
    var textViewSeparatorView: UIView
    var composeAccessoryView: DreamInputAccessoryView
    
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
    weak var inputDelegate: DoneButtonAdjustable?
    
    init() {
        state = .Keep
        
        composeAccessoryView = DreamInputAccessoryView()
        composeAccessoryView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60.0)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Courier", size: 16.0)
        textView.text = " What did you dream about?..."
        textView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        textView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.54)
        textView.selectable = true
        textView.contentInset = UIEdgeInsetsMake(18.0, 6.0, 0.0, 24.0)
        textView.inputAccessoryView = composeAccessoryView
        
        shareLabel = UILabel()
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        shareLabel.text = "share".uppercaseString
        shareLabel.textAlignment = .Center
        shareLabel.textColor = UIColor.lightGreyBlue()
        shareLabel.userInteractionEnabled = true
        
        keepLabel = UILabel()
        keepLabel.translatesAutoresizingMaskIntoConstraints = false
        keepLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        keepLabel.text = "keep".uppercaseString
        keepLabel.textAlignment = .Center
        keepLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.userInteractionEnabled = true
        
        borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.12)
        
        highlightLine = UIView()
        highlightLine.translatesAutoresizingMaskIntoConstraints = false
        highlightLine.backgroundColor = UIColor.primaryPurple()
        
        dreamTitleLabel = UITextField()
        dreamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 18.0)
        dreamTitleLabel.attributedPlaceholder = NSAttributedString(string: "Add Title", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        dreamTitleLabel.textAlignment = .Left
        dreamTitleLabel.textColor = UIColor.whiteColor()
        dreamTitleLabel.returnKeyType = .Done
        dreamTitleLabel.inputAccessoryView = composeAccessoryView
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.textAlignment = .Center

        textViewSeparatorView = UIView()
        textViewSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        textViewSeparatorView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.12)
        
        dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .FullStyle
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        composeAccessoryView.delegate = self
        inputDelegate = composeAccessoryView
        
        shareTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.shareTapped))
        keepTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.keepTapped))
        shareLabel.addGestureRecognizer(shareTapRecognizer!)
        keepLabel.addGestureRecognizer(keepTapRecognizer!)
        
        dreamTitleLabel.delegate = self
        textView.delegate = self
        
        view.addSubview(dreamTitleLabel)
        view.addSubview(dateLabel)
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
        
        let logoImageView = UILabel()
        logoImageView.text = "compose".uppercaseString
        logoImageView.frame = CGRectMake(0, 0, 100, 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.whiteColor()
        logoImageView.textAlignment = .Center
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRectMake(0, 0, 50, 25)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        cancelButton.addTarget(self, action: #selector(NewDreamViewController.cancelTapped), forControlEvents: .TouchUpInside)
        
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.titleView = logoImageView
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
        if textView.text == " What did you dream about?..." {
            textView.text = " "
        }
        
        if let keyboardHeight = keyboardHeight {
            textViewBottomConstraint?.constant = -keyboardHeight
            
            UIView.animateWithDuration(0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == " " {
            textView.text = " What did you dream about?..."
        } else {
            saveText = textView.text
        }
        
        textViewBottomConstraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.length > 1 && textView.text != " What did you dream about?..." && dreamTitleLabel.text?.isEmpty == false {
            inputDelegate?.updateDoneButton("highlighted")
        } else {
            inputDelegate?.updateDoneButton("disabled")
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        keyboardHeight = frame.height
    }
    
    func shareTapped() {
        shareLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.textColor = UIColor.lightGreyBlue()
        state = .Share
        
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
        if dreamTitleLabel.text?.isEmpty == false && textView.text != " What did you dream about?..." && textView.text != " " {
            if state == .Keep {
                if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                    let text = String(textView.text.characters.dropFirst())
                    let dreamDictionary = ["title":dreamTitleLabel.text!, "author":"\(username)", "text":text, "date":"\(nowString!)", "stars":0]
                    FIRDatabase.database().reference().child("/users/\(username)/journals").childByAutoId().setValue(dreamDictionary)
                    
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
                    FIRDatabase.database().reference().child("/feed").childByAutoId().setValue(dreamDictionary)
                    FIRDatabase.database().reference().child("/users/\(username)/journals").childByAutoId().setValue(dreamDictionary)
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
        } else if textView.text == " What did you dream about?..." || textView.text == " " {
            let alert = UIAlertController(title: "Whoops!", message: "No dream to upload. Type your dream in the text view below.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func stateDidChange(state: String) {
        if state == "public" {
            self.state = .Share
        } else {
            self.state = .Keep
        }
    }
    
    func doneButtonTapped() {
        sendTapped()
    }
    
    func setupLayout() {
        textViewBottomConstraint = textView.al_bottom == view.al_bottom
        
        view.addConstraints([
            textView.al_top == textViewSeparatorView.al_bottom,
            textViewBottomConstraint!,
            textView.al_left == view.al_left + 5,
            textView.al_right == view.al_right - 5,
            
            dreamTitleLabel.al_top == dateLabel.al_bottom + 27,
            dreamTitleLabel.al_left == view.al_left + 24,
            dreamTitleLabel.al_right == view.al_right - 24,
            
            dateLabel.al_centerX == view.al_centerX,
            dateLabel.al_top == view.al_top + 24,
            
            textViewSeparatorView.al_height == 2.0,
            textViewSeparatorView.al_left == view.al_left + 24,
            textViewSeparatorView.al_right == view.al_right - 24,
            textViewSeparatorView.al_top == dreamTitleLabel.al_bottom + 24
        ])
    }
}

protocol NewDreamViewControllerAnimatable: class {
    func shouldLeaveNewDreamViewController(index: Int)
}

protocol DoneButtonAdjustable: class {
    func updateDoneButton(state: String)
}
