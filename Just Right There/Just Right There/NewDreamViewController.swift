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
        case share
        case keep
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
    
    var dateFormatter: DateFormatter
    var now: Date?
    var nowString: String?
    var keyboardHeight: CGFloat?
    weak var delegate: NewDreamViewControllerAnimatable?
    weak var inputDelegate: DoneButtonAdjustable?
    
    init() {
        state = .keep
        
        composeAccessoryView = DreamInputAccessoryView()
        composeAccessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60.0)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Courier", size: 16.0)
        textView.text = " What did you dream about?..."
        textView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        textView.textColor = UIColor.white.withAlphaComponent(0.54)
        textView.isSelectable = true
        textView.contentInset = UIEdgeInsetsMake(18.0, 6.0, 0.0, 24.0)
        textView.inputAccessoryView = composeAccessoryView
        
        shareLabel = UILabel()
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        shareLabel.text = "share".uppercased()
        shareLabel.textAlignment = .center
        shareLabel.textColor = UIColor.lightGreyBlue()
        shareLabel.isUserInteractionEnabled = true
        
        keepLabel = UILabel()
        keepLabel.translatesAutoresizingMaskIntoConstraints = false
        keepLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        keepLabel.text = "keep".uppercased()
        keepLabel.textAlignment = .center
        keepLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.isUserInteractionEnabled = true
        
        borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        highlightLine = UIView()
        highlightLine.translatesAutoresizingMaskIntoConstraints = false
        highlightLine.backgroundColor = UIColor.primaryPurple()
        
        dreamTitleLabel = UITextField()
        dreamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 18.0)
        dreamTitleLabel.attributedPlaceholder = NSAttributedString(string: "Add Title", attributes: [NSForegroundColorAttributeName: UIColor.white])
        dreamTitleLabel.textAlignment = .left
        dreamTitleLabel.textColor = UIColor.white
        dreamTitleLabel.returnKeyType = .done
        dreamTitleLabel.inputAccessoryView = composeAccessoryView
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.textAlignment = .center

        textViewSeparatorView = UIView()
        textViewSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        textViewSeparatorView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
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

        NotificationCenter.default.addObserver(self, selector: #selector(NewDreamViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        now = Date()
        nowString = dateFormatter.string(from: now!)
        dateLabel.text = nowString
        
        let logoImageView = UILabel()
        logoImageView.text = "compose".uppercased()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.white
        logoImageView.textAlignment = .center
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        cancelButton.addTarget(self, action: #selector(NewDreamViewController.cancelTapped), for: .touchUpInside)
        
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.titleView = logoImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hasSeenToolTip = UserDefaults.standard.bool(forKey: "newdreamtooltip")
        
        if hasSeenToolTip {
            // coolio
        } else {
            // show tip
            let alert = UIAlertController(title: "Important!!!", message: "Before you press the done button on your dream, make sure you select the correct tab to \"Share\" it or just \"Keep\" it in your journal!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "newdreamtooltip")
        }
        
        if saveText != "" {
            textView.text = saveText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
        dreamTitleLabel.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == " What did you dream about?..." {
            textView.text = " "
        }
        
        if let keyboardHeight = keyboardHeight {
            textViewBottomConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == " " {
            textView.text = " What did you dream about?..."
        } else {
            saveText = textView.text
        }
        
        textViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 1 && textView.text != " What did you dream about?..." && dreamTitleLabel.text?.isEmpty == false {
            self.inputDelegate?.updateDoneButton("highlighted")
        } else {
            self.inputDelegate?.updateDoneButton("disabled")
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let frame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = frame.height
    }
    
    func shareTapped() {
        shareLabel.textColor = UIColor.primaryDarkBlue()
        keepLabel.textColor = UIColor.lightGreyBlue()
        state = .share
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keepTapped() {
        shareLabel.textColor = UIColor.lightGreyBlue()
        keepLabel.textColor = UIColor.navyColor()
        state = .keep
        
        highlightLeftConstraint?.constant = 0.0
        highlightRightConstraint?.constant = 0.0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func cancelTapped() {
        saveText = ""
        dismiss(animated: true, completion: nil)
        
    }
    
    func sendTapped() {
        if dreamTitleLabel.text?.isEmpty == false && textView.text != " What did you dream about?..." && textView.text != " " {
            if state == .keep {
                if let username = UserDefaults.standard.string(forKey: "username") {
                    let text = String(textView.text.characters.dropFirst())
                    let now = nowString
                    let dreamDictionary = [
                        "title":dreamTitleLabel.text!,
                        "author":"\(username)",
                        "text":text,
                        "date":"\(now)",
                        "upvotes":0,
                        "downvotes":0
                    ] as [String : Any]
                    FIRDatabase.database().reference().child("/users/\(username)/journals").childByAutoId().setValue(dreamDictionary)
                    
                    if let journals = UserDefaults.standard.object(forKey: "journals") as? [[String:AnyObject]] {
                        let journalsCopy = NSMutableArray(array: journals)
                        journalsCopy.add(dreamDictionary)
                        UserDefaults.standard.set(journalsCopy, forKey: "journals")
                    } else {
                        let newJournalsArray = [dreamDictionary]
                        UserDefaults.standard.set(newJournalsArray, forKey: "journals")
                    }
                }
            } else if state == .share {
                if let username = UserDefaults.standard.string(forKey: "username") {
                    let text = dreamTitleLabel.text!
                    let dreamDictionary = [
                        "title":text,
                        "author":"\(username)",
                        "text":textView.text,
                        "date":"\(nowString!)",
                        "upvotes":0,
                        "downvotes":0
                    ] as [String : Any]
                    let ref = FIRDatabase.database().reference().child("/feed").childByAutoId()
                    let id = ref.key
                    ref.setValue(dreamDictionary)
                    FIRDatabase.database().reference().child("/users/\(username)/journals/\(id)").setValue(dreamDictionary)
                }
            }
            
            saveText = ""
            textView.text = ""
            dreamTitleLabel.text = ""
            delegate?.shouldLeaveNewDreamViewController(2)
        } else if dreamTitleLabel.text?.isEmpty == true {
            if state == .keep {
                    let alert = UIAlertController(title: "Don't Forget A Title!", message: "Before you save that dream of yours, make sure you give it name.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Don't Forget A Title!", message: "Before you share that masterpiece, give your work a title.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if textView.text == " What did you dream about?..." || textView.text == " " {
            let alert = UIAlertController(title: "Whoops!", message: "No dream to upload. Type your dream in the text view below.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func stateDidChange(_ state: String) {
        if state == "public" {
            self.state = .share
        } else {
            self.state = .keep
        }
    }
    
    func doneButtonTapped() {
        sendTapped()
        dismiss(animated: true, completion: nil)
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
    func shouldLeaveNewDreamViewController(_ index: Int)
}

protocol DoneButtonAdjustable: class {
    func updateDoneButton(_ state: String)
}
