//
//  DreamReaderViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 11/9/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase

class DreamReaderViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    var scrollView: UIScrollView
    var headerView: DreamReaderHeaderView
    var textView: UITextView
    let screenWidth = UIScreen.main.bounds.width
    var dream: Dream
    
    var currentTitle: String
    var currentAuthor: String
    var currentText: String
    var currentId: String
    
    var id: String?
    var currentState: DreamState
    var karma: Int = 0
    
    enum DreamState {
        case delete
        case save
    }
    
    let alphabet = ["a","b","c","d","e","f","g",
                    "h","i","j","k","l","m","n",
                    "o","p","q","r","s","t","u",
                    "v","w","x","y","z",]
    
    init(dream: Dream) {
        self.dream = dream
        currentTitle = dream.title
        currentAuthor = dream.author
        currentText = dream.text
        currentId = dream.id
        
        scrollView = UIScrollView()
        
        headerView = DreamReaderHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
        headerView.dreamTitle.text = dream.title
        headerView.profileView.authorLabel.text = dream.author
        headerView.profileView.dateLabel.text = dream.date
        headerView.starLabel.text = "\(dream.upvotes - dream.downvotes)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.74)
        ]
        
        textView = UITextView()
        textView.attributedText = NSAttributedString(string: dream.text, attributes: attributes)
    
        let newSize = textView.sizeThatFits(CGSize(width: screenWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame = CGRect(x: 12, y: 200, width: screenWidth - 24.0, height: newSize.height + 75.0)
        textView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.contentInset = UIEdgeInsetsMake(12.0, 12.0, 0.0, 12.0)
        textView.isUserInteractionEnabled = true
        
        currentState = .delete
        karma = dream.upvotes - dream.downvotes
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        headerView.upvoteButton.addTarget(self, action: #selector(DreamReaderViewController.upvoteTapped), for: .touchUpInside)
        headerView.downvoteButton.addTarget(self, action: #selector(DreamReaderViewController.downvoteTapped), for: .touchUpInside)
        headerView.profileView.commentButton.addTarget(self, action: #selector(DreamReaderViewController.openComments), for: .touchUpInside)
        headerView.profileView.commentLabel.text = "\(dream.comments.count)"
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(textView)
        view.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: screenWidth, height: headerView.bounds.height + textView.bounds.height + 30.0)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let username = UserDefaults.standard.string(forKey: "username") {
            if currentAuthor == username {
                textView.isEditable = true
            } else {
                textView.isEditable = false
            }
        }
        
        let reportFlag = UIButton()
        reportFlag.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(13.0, 5.0, 13.0, 5.0)
        reportFlag.setImage(UIImage(named: "more"), for: .normal)
        reportFlag.addTarget(self, action: #selector(DreamViewController.flagTapped), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: reportFlag)
        navigationItem.rightBarButtonItem = rightBarButton
        
        setProfileImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if starredIds.contains(currentId) {
            headerView.upvoteButton.isSelected = true
        }
        
        if downvoteIds.contains(currentId) {
            headerView.downvoteButton.isSelected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentState = .save
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        currentState = .delete
    }
    
    func upvoteTapped() {
        if headerView.upvoteButton.isSelected {
            headerView.upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username") {
                headerView.starLabel.text = "\(karma - 1)"
                
                FIRDatabase.database().reference().child("feed/\(currentId)/upvotes").setValue(dream.upvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(currentId)").removeValue()
            }
        } else {
            headerView.upvoteButton.isSelected = true
            headerView.downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username") {
                if !starredIds.contains(currentId) {
                    headerView.starLabel.text = "\(self.karma + 1)"
                    
                    if let title = headerView.dreamTitle.text,
                        let author = headerView.profileView.authorLabel.text,
                        let text = textView.text,
                        let date = headerView.profileView.dateLabel.text {
                        
                        let dreamDictionary = [
                            "title":title,
                            "author":author,
                            "text":text,
                            "date":"\(date)",
                            "upvotes": dream.upvotes + 1,
                            "downvotes": dream.downvotes
                        ] as [String : Any]
                        
                        FIRDatabase.database().reference().child("feed/\(currentId)/upvotes").setValue(dream.upvotes + 1)
                        FIRDatabase.database().reference().child("/users/\(username)/starred/\(currentId)").setValue(dreamDictionary)
                    }
                }
            }
        }
    }
    
    func downvoteTapped() {
        if headerView.downvoteButton.isSelected {
            headerView.downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                headerView.upvoteButton.isSelected = false
                headerView.starLabel.text = "\(karma - 1)"
                
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(dream.downvotes - 1)
                FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
            }
        } else {
            headerView.downvoteButton.isSelected = true
            headerView.upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                headerView.upvoteButton.isSelected = false
                headerView.starLabel.text = "\(karma + 1)"
                
                if let title = headerView.dreamTitle.text,
                    let author = headerView.profileView.authorLabel.text,
                    let text = textView.text,
                    let date = headerView.profileView.dateLabel.text {
                    
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
            if textView.text?.isEmpty == false {
                if let username = UserDefaults.standard.string(forKey: "username") {
                    FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)/text").setValue(textView.text)
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
    
    func openComments() {
        let viewModel = CommentViewModel(dream: dream)
        let vc = CommentCollectionViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
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
    
    func setProfileImage() {
        let letter: String = dream.author[0..<1]
        let index = alphabet.index(of: letter.lowercased())
        
        if index == 0 || index == 14 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "alien-head"), for: .normal)
        } else if index == 1 || index == 14 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "atom"), for: .normal)
        } else if index == 2 || index == 15 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "brain"), for: .normal)
        } else if index == 3 || index == 16 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "circus-camel"), for: .normal)
        } else if index == 4 || index == 17 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "cloud-and-moon"), for: .normal)
        } else if index == 5 || index == 18 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "earth-globe"), for: .normal)
        } else if index == 6 || index == 19 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "fire-gear"), for: .normal)
        } else if index == 7 || index == 20 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "flask"), for: .normal)
        } else if index == 8 || index == 21 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "giraffe"), for: .normal)
        } else if index == 9 || index == 22 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "hot-air-balloon"), for: .normal)
        } else if index == 10 || index == 23 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "islamic-art-1"), for: .normal)
        } else if index == 11 || index == 24 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "islamic-art-2"), for: .normal)
        } else if index == 12 || index == 25 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "oil-lamp"), for: .normal)
        } else if index == 13 || index == 26 {
            headerView.profileView.profileImageView.setImage(UIImage(named: "saturn"), for: .normal)
        }
    }
}
