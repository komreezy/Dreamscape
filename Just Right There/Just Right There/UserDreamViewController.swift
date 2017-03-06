//
//  UserDreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase

class UserDreamViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
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
        case delete
        case save
    }
    
    init(title: String, author: String, text: String, id: String) {
        currentTitle = title
        currentAuthor = author
        currentText = text
        currentId = id
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(UIImage(named: "close"), for: UIControlState())
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(11.0, 11.0, 11.0, 11.0)
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Montserrat-Regular", size: 20.0)
        dreamTitle.textColor = UIColor.white
        dreamTitle.textAlignment = .center
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Courier", size: 14.0)
        authorLabel.textColor = UIColor.white
        dreamTitle.textAlignment = .center
        authorLabel.text = "edit mode"
        
        dreamTextView = UITextView()
        dreamTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamTextView.backgroundColor = UIColor.white
        dreamTextView.font = UIFont(name: "Courier", size: 17.0)
        dreamTextView.showsVerticalScrollIndicator = false
        dreamTextView.text = currentText
        dreamTextView.textColor = UIColor.white
        dreamTextView.backgroundColor = UIColor(fromHexString: "#222326")
        dreamTextView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)
        
        reportFlag = UIButton()
        reportFlag.translatesAutoresizingMaskIntoConstraints = false
        reportFlag.setImage(UIImage(named: "flag"), for: UIControlState())
        reportFlag.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Delete", for: UIControlState())
        saveButton.setTitleColor(WhiteColor, for: UIControlState())
        saveButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        currentState = .delete
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(fromHexString: "#222326")
        
        dismissButton.addTarget(self, action: #selector(DreamViewController.dismissViewController), for: .touchUpInside)
        reportFlag.addTarget(self, action: #selector(DreamViewController.flagTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(DreamViewController.saveTapped), for: .touchUpInside)
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
        
        if let username = UserDefaults.standard.string(forKey: "username") {
            if currentAuthor == username {
                dreamTextView.isEditable = true
                
                reportFlag.isUserInteractionEnabled = false
                reportFlag.alpha = 0
            } else {
                dreamTextView.isEditable = false
                
                reportFlag.isUserInteractionEnabled = true
                reportFlag.alpha = 1
                
                saveButton.isUserInteractionEnabled = false
                saveButton.alpha = 0
            }
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentState = .save
        saveButton.setTitle("Save", for: UIControlState())
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        currentState = .delete
        saveButton.setTitle("Delete", for: UIControlState())
    }
    
    func saveTapped() {
        if currentState == .save {
            if dreamTextView.text?.isEmpty == false {
                if let username = UserDefaults.standard.string(forKey: "username") {
                    let userRef = FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)/text")
                    userRef.setValue(dreamTextView.text)
                }
            }
        } else {
            if let username = UserDefaults.standard.string(forKey: "username") {
                let userRef = FIRDatabase.database().reference().child("/users/\(username)/journals/\(currentId)")
                userRef.removeValue()
                FIRDatabase.database().reference().child("/feed/\(currentId)").removeValue()
            }
            
            UserDefaults.standard.set(nil, forKey: "journals")
        }
        dismiss(animated: true, completion: nil)
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
            headerView.al_top == view.al_top,
            headerView.al_left == view.al_left,
            headerView.al_right == view.al_right,
            headerView.al_height == 110
        ])
        
        view.addConstraints([
            dismissButton.al_left == headerView.al_left + 5,
            dismissButton.al_centerY == dreamTitle.al_bottom,
            dismissButton.al_height == 35,
            dismissButton.al_width == 35
        ])
        
        view.addConstraints([
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_centerY == headerView.al_centerY - 7,
            dreamTitle.al_left == dismissButton.al_right,
            dreamTitle.al_right == reportFlag.al_left
        ])
        
        view.addConstraints([
            authorLabel.al_centerX == dreamTitle.al_centerX,
            authorLabel.al_top == dreamTitle.al_bottom + 5
        ])
        
        view.addConstraints([
            dreamTextView.al_left == view.al_left + 20,
            dreamTextView.al_bottom == view.al_bottom,
            dreamTextView.al_right == view.al_right - 20,
            dreamTextView.al_top == headerView.al_bottom
        ])
        
        view.addConstraints([
            reportFlag.al_right == view.al_right - 12,
            reportFlag.al_centerY == headerView.al_centerY - 3,
            reportFlag.al_width == 27,
            reportFlag.al_height == 31.5
        ])
        
        view.addConstraints([
            saveButton.al_right == view.al_right - 15,
            saveButton.al_centerY == dreamTitle.al_bottom,
            saveButton.al_width == 55,
            saveButton.al_height == 35
        ])
    }
}
