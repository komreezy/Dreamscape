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
    var upvoteButton: UIButton
    var downvoteButton: UIButton
    var starLabel: UILabel
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
        case delete
        case save
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
        shareButton.backgroundColor = UIColor.clear
        shareButton.layer.cornerRadius = 4.0
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        shareButton.setTitle("share".uppercased(), for: UIControlState())
        shareButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState())
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        topDividerView = UIView()
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        bottomDividerView = UIView()
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Montserrat", size: 22.0)
        dreamTitle.textColor = UIColor.white
        dreamTitle.textAlignment = .left
        dreamTitle.numberOfLines = 3
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Montserrat", size: 14.0)
        authorLabel.textColor = UIColor.white
        authorLabel.text = "by \(currentAuthor)"
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.text = dream.date
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        
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
        dreamTextView.isScrollEnabled = false
        dreamTextView.attributedText = NSAttributedString(string: currentText, attributes: attributes)
        dreamTextView.textColor = UIColor.white.withAlphaComponent(0.74)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Delete", for: UIControlState())
        saveButton.setTitleColor(WhiteColor, for: UIControlState())
        saveButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        upvoteButton = UIButton()
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.setImage(UIImage(named: "upvote"), for: UIControlState())
        upvoteButton.setImage(UIImage(named: "upvote-highlighted"), for: .selected)
        
        downvoteButton = UIButton()
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.setImage(UIImage(named: "downvote"), for: UIControlState())
        downvoteButton.setImage(UIImage(named: "downvote-highlighted"), for: .selected)
        
        starLabel = UILabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .center
        
        currentState = .delete
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        saveButton.addTarget(self, action: #selector(DreamViewController.saveTapped), for: .touchUpInside)
        upvoteButton.addTarget(self, action: #selector(DreamViewController.upvoteTapped), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(DreamViewController.downvoteTapped), for: .touchUpInside)
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

        if let username = UserDefaults.standard.string(forKey: "username") {
            if currentAuthor == username {
                dreamTextView.isEditable = true
            } else {
                dreamTextView.isEditable = false
                
                saveButton.isUserInteractionEnabled = false
                saveButton.alpha = 0
            }
        }
        
        let reportFlag = UIButton()
        reportFlag.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(13.0, 5.0, 13.0, 5.0)
        reportFlag.setImage(UIImage(named: "more"), for: UIControlState())
        reportFlag.addTarget(self, action: #selector(DreamViewController.flagTapped), for: .touchUpInside)
        
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
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentState = .save
        saveButton.setTitle("Save", for: UIControlState())
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        currentState = .delete
        saveButton.setTitle("Delete", for: UIControlState())
    }
    
    func upvoteTapped() {
        if upvoteButton.isSelected {
            upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                starLabel.text = "\(karma - 1)"
    
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(dream.upvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
            }
        } else {
            upvoteButton.isSelected = true
            downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                if !starredIds.contains(id) {
                    starLabel.text = "\(self.karma + 1)"
                    
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
        if downvoteButton.isSelected {
            downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                upvoteButton.isSelected = false
                starLabel.text = "\(karma - 1)"
                
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(dream.downvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
            }
        } else {
            downvoteButton.isSelected = true
            upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                upvoteButton.isSelected = false
                starLabel.text = "\(karma + 1)"
                
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
        if currentState == .save {
            if dreamTextView.text?.isEmpty == false {
                if let username = UserDefaults.standard.string(forKey: "username") {
                    FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)/text").setValue(dreamTextView.text)
                }
            }
        } else {
            if let username = UserDefaults.standard.string(forKey: "username") {
                FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)").removeValue()
                FIRDatabase.database().reference().child("/feed/\(currentId)").removeValue()
            }
            
            UserDefaults.standard.set(nil, forKey: "journals")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func flagTapped() {
        FIRDatabase.database().reference().child("/reported/\(currentAuthor)").setValue(true)
        
        if MFMailComposeViewController.canSendMail() {
            launchEmail(self)
        } else {
            let alert = UIAlertController(title: "Unable To Report", message: "Please set up mail client before reporting.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func setupLayout() {
        view.addConstraints([
            headerView.al_top == scrollView.al_top,
            headerView.al_left == scrollView.al_left,
            headerView.al_right == scrollView.al_right,
            headerView.al_height == UIScreen.main.bounds.height * 0.25
        ])

        view.addConstraints([
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_top == headerView.al_top + 30,
            dreamTitle.al_left == view.al_left + 20,
            dreamTitle.al_right == view.al_right - 35
        ])
        
        view.addConstraints([
            authorLabel.al_left == profileImageView.al_right + 12,
            authorLabel.al_bottom == profileImageView.al_centerY
        ])
        
        view.addConstraints([
            dateLabel.al_left == authorLabel.al_left,
            dateLabel.al_top == authorLabel.al_bottom + 2
        ])
        
        view.addConstraints([
            dreamTextView.al_left == scrollView.al_left + 20,
            dreamTextView.al_bottom == scrollView.al_bottom,
            dreamTextView.al_right == scrollView.al_right - 20,
            dreamTextView.al_top == bottomDividerView.al_bottom + 12
        ])
        view.addConstraints([
            profileImageView.al_left == headerView.al_left + 24,
            profileImageView.al_centerY == bottomDividerView.al_top - UIScreen.main.bounds.height * 0.07,
            profileImageView.al_height == 36,
            profileImageView.al_width == 36
        ])
        
        view.addConstraints([
            saveButton.al_right == view.al_right - 15,
            saveButton.al_centerY == headerView.al_centerY - 5,
            saveButton.al_width == 55,
            saveButton.al_height == 35
        ])
        
        view.addConstraints([
            scrollView.al_bottom == view.al_bottom,
            scrollView.al_top == view.al_top,
            scrollView.al_left == view.al_left,
            scrollView.al_right == view.al_right
        ])
        
        view.addConstraints([
            topDividerView.al_left == view.al_left + 24,
            topDividerView.al_right == view.al_right - 24,
            topDividerView.al_top == dreamTitle.al_bottom + 24,
            topDividerView.al_height == 1
        ])
        
        view.addConstraints([
            upvoteButton.al_right == downvoteButton.al_left - 12,
            upvoteButton.al_centerY == dreamTitle.al_centerY,
            upvoteButton.al_height == 24,
            upvoteButton.al_width == 24
        ])
        
        view.addConstraints([
            downvoteButton.al_right == headerView.al_right - 24,
            downvoteButton.al_centerY == dreamTitle.al_centerY,
            downvoteButton.al_height == 24,
            downvoteButton.al_width == 24
        ])
        
        view.addConstraints([
            bottomDividerView.al_left == view.al_left + 24,
            bottomDividerView.al_right == view.al_right - 24,
            bottomDividerView.al_top == headerView.al_bottom,
            bottomDividerView.al_height == 1
        ])
        
        view.addConstraints([
            starLabel.al_centerY == upvoteButton.al_centerY,
            starLabel.al_right == upvoteButton.al_left - 12
        ])
    }
}
