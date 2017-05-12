//
//  AddCommentViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 5/11/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController,
    UITextFieldDelegate,
    UITextViewDelegate,
    CommentAccessoryViewDelegate {
    
    var textView: UITextView
    var dateLabel: UILabel
    var textViewSeparator: UIView
    var composeAccessoryView: CommentAccessoryView
    
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
    
    var dream: Dream
    
    init(dream: Dream) {
        self.dream = dream
        
        composeAccessoryView = CommentAccessoryView()
        composeAccessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60.0)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Courier", size: 16.0)
        textView.text = "What did you think about this dream?..."
        textView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        textView.textColor = UIColor.white.withAlphaComponent(0.54)
        textView.isSelectable = true
        textView.inputAccessoryView = composeAccessoryView
        
        textViewSeparator = UIView()
        textViewSeparator.translatesAutoresizingMaskIntoConstraints = false
        textViewSeparator.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.textAlignment = .center
        
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "MMMM d, yyyy"
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        composeAccessoryView.delegate = self
        inputDelegate = composeAccessoryView
    
        textView.delegate = self
        
        view.addSubview(dateLabel)
        view.addSubview(textView)
        view.addSubview(textViewSeparator)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NewDreamVersionViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        now = Date()
        nowString = dateFormatter.string(from: now!)
        dateLabel.text = nowString
        
        let logoImageView = UILabel()
        logoImageView.text = "add comment".uppercased()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.white
        logoImageView.textAlignment = .center
        
        navigationItem.titleView = logoImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateButton() {
        if textView.text != "What did you think about this dream?..." {
            self.inputDelegate?.updateDoneButton("highlighted")
        } else {
            self.inputDelegate?.updateDoneButton("disabled")
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What did you think about this dream?..." {
            textView.text = ""
        }
        
        if let keyboardHeight = keyboardHeight {
            textViewBottomConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What did you think about this dream?..."
        } else {
            saveText = textView.text
        }
        
        textViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "What did you think about this dream?..." {
            self.inputDelegate?.updateDoneButton("highlighted")
        } else {
            self.inputDelegate?.updateDoneButton("disabled")
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let frame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = frame.height
    }
    
    func sendTapped() {
        if let now = nowString,
            let username = UserDefaults.standard.string(forKey: "username") {
            let commentDictionary = [
                "author":"\(username)",
                "text":textView.text ?? "",
                "date":"\(now)"
                ] as [String : Any]
            
            FIRDatabase.database().reference().child("/feed/\(dream.id)/comments").childByAutoId().setValue(commentDictionary)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func doneButtonTapped() {
        sendTapped()
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        textViewBottomConstraint = textView.al_bottom == view.al_bottom
        
        view.addConstraints([
            textView.al_top == textViewSeparator.al_bottom + 15,
            textViewBottomConstraint!,
            textView.al_left == view.al_left + 21,
            textView.al_right == view.al_right - 21
        ])
    
        view.addConstraints([
            dateLabel.al_centerX == view.al_centerX,
            dateLabel.al_top == view.al_top + 20
        ])
        
        view.addConstraints([
            textViewSeparator.al_left == view.al_left + 24,
            textViewSeparator.al_right == view.al_right - 24,
            textViewSeparator.al_top == dateLabel.al_bottom + 15,
            textViewSeparator.al_height == 1
        ])
    }
}
