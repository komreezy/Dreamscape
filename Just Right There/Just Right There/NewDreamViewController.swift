//
//  NewDreamViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Speech

var saveText: String = ""

@available(iOS 10.0, *)
class NewDreamViewController: UIViewController,
UITextFieldDelegate,
UITextViewDelegate,
ComposeAccessoryViewDelegate,
SFSpeechRecognizerDelegate {

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
    var recordingLabel: UILabel
    var redDot: UIView
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
    
    var firstBubble: CircleView
    var secondBubble: CircleView
    var thirdBubble: CircleView
    var recording = false
    var audioEngine = AVAudioEngine()
    var timer: Timer?
    
    let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var savedText = ""
    var currentRecording = ""
    var saved = false
    
    init() {
        state = .keep
        
        composeAccessoryView = DreamInputAccessoryView()
        composeAccessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60.0)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Courier", size: 16.0)
        textView.text = "What did you dream about?..."
        textView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        textView.textColor = UIColor.white.withAlphaComponent(0.54)
        textView.isSelectable = true
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
        
        firstBubble = CircleView()
        firstBubble.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        secondBubble = CircleView()
        secondBubble.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        thirdBubble = CircleView()
        thirdBubble.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        recordingLabel = UILabel()
        recordingLabel.translatesAutoresizingMaskIntoConstraints = false
        recordingLabel.text = "recording".uppercased()
        recordingLabel.font = UIFont(name: "Montserrat", size: 26.0)
        recordingLabel.textColor = .white
        recordingLabel.textAlignment = .center
        recordingLabel.alpha = 0
        
        redDot = UIView()
        redDot.translatesAutoresizingMaskIntoConstraints = false
        redDot.backgroundColor = .red
        redDot.layer.cornerRadius = 9.0
        redDot.alpha = 0
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        composeAccessoryView.delegate = self
        inputDelegate = composeAccessoryView
        
        firstBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        secondBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        thirdBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        
        shareTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.shareTapped))
        keepTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDreamViewController.keepTapped))
        dreamTitleLabel.addTarget(self, action: #selector(NewDreamViewController.updateButton), for: .editingChanged)
        shareLabel.addGestureRecognizer(shareTapRecognizer!)
        keepLabel.addGestureRecognizer(keepTapRecognizer!)
        
        dreamTitleLabel.delegate = self
        textView.delegate = self
        
        view.addSubview(dreamTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(textView)
        view.addSubview(textViewSeparatorView)
        view.addSubview(thirdBubble)
        view.addSubview(firstBubble)
        view.addSubview(secondBubble)
        view.addSubview(recordingLabel)
        view.addSubview(redDot)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NewDreamViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
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
        
        let recordButton = UIButton()
        recordButton.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        recordButton.setTitle("Record", for: UIControlState())
        recordButton.setTitleColor(UIColor.white, for: UIControlState())
        recordButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        recordButton.addTarget(self, action: #selector(NewDreamViewController.startRecording), for: .touchUpInside)
        
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        let recordBarButton = UIBarButtonItem(customView: recordButton)
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = recordBarButton
        navigationItem.titleView = logoImageView
        
        recognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hasSeenToolTip = UserDefaults.standard.bool(forKey: "newdreamtooltip")
        
        if hasSeenToolTip {
            // coolio
        } else {
            // show tip
            let alert = UIAlertController(title: "Important!!!",
                                          message: "Before you press the done button on your dream, make sure you select the correct tab to \"Share\" it or just \"Keep\" it in your journal!",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
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
    
    func updateButton() {
        if dreamTitleLabel.text != "Add Title" && textView.text != "What did you dream about?..." && dreamTitleLabel.text != "" {
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
        dreamTitleLabel.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What did you dream about?..." {
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
            textView.text = "What did you dream about?..."
        } else {
            saveText = textView.text
        }
        
        textViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "What did you dream about?..." && dreamTitleLabel.text != "" {
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
    
    func startRecording() {
        if #available(iOS 10.0, *) {
            if audioEngine.isRunning {
                timer?.invalidate()
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.recordingLabel.alpha = 0
                    self.redDot.alpha = 0
                })
                
                let item = self.navigationItem.rightBarButtonItem
                let button = item!.customView as! UIButton
                button.setTitle("Record", for:.normal)
                
                audioEngine.stop()
                audioEngine.inputNode?.removeTap(onBus: 0)
                recognitionRequest?.endAudio()
                
                savedText = savedText + currentRecording + " "
                saved = true
            } else {
                saved = false
                
                let item = self.navigationItem.rightBarButtonItem
                let button = item!.customView as! UIButton
                button.setTitle("Stop", for:.normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.recordingLabel.alpha = 1
                    self.redDot.alpha = 1
                })
                
                timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { _ in
                    self.firstBubble.resizeCircleWithPulseAinmation(100.0, duration: 1.0)
                    self.secondBubble.resizeCircleWithPulseAinmation(50.0, duration: 0.7)
                    self.thirdBubble.resizeCircleWithPulseAinmation(250.0, duration: 2.0)
                })
                
                if recognitionTask != nil {
                    recognitionTask?.cancel()
                    recognitionTask = nil
                }
                
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryRecord)
                    try audioSession.setMode(AVAudioSessionModeMeasurement)
                    try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
                } catch {
                    print("audio settings fail")
                }
                
                recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                
                guard let inputNode = audioEngine.inputNode else {
                    return
                }
                
                recognitionRequest?.shouldReportPartialResults = true
                
                recognitionTask = recognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (result, error) in
                    var isFinal = false
                    
                    if result != nil && !self.saved {
                        self.textView.text = self.savedText + (result?.bestTranscription.formattedString)!
                        self.currentRecording = (result?.bestTranscription.formattedString)!
                        isFinal = (result?.isFinal)!
                    }
                    
                    if error != nil || isFinal {
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        
                        self.recognitionRequest = nil
                        self.recognitionTask = nil
                    }
                })
                
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when) in
                    self.recognitionRequest?.append(buffer)
                })
                
                audioEngine.prepare()
                
                do {
                    try audioEngine.start()
                } catch {
                    print("audio engine failed")
                }
                
                //textView.text = "Say Something, I'm Listening"
            }
            
        } else {
            let alert = UIAlertController(title: "Sorry!", message: "You need iOS 10 to use the record feature", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
    }

    func sendTapped() {
        if dreamTitleLabel.text?.isEmpty == false && textView.text != "What did you dream about?..." && textView.text != "z" {
            if state == .keep {
                if let username = UserDefaults.standard.string(forKey: "username"), let now = nowString {
                    let text = String(textView.text.characters.dropFirst())
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
                    let alert = UIAlertController(title: "Don't Forget A Title!",
                                                  message: "Before you save that dream of yours, make sure you give it name.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay",
                                                  style: UIAlertActionStyle.default,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Don't Forget A Title!",
                                              message: "Before you share that masterpiece, give your work a title.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if textView.text == "What did you dream about?..." || textView.text == "" {
            let alert = UIAlertController(title: "Whoops!",
                                          message: "No dream to upload. Type your dream in the text view below.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
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
            textView.al_top == textViewSeparatorView.al_bottom + 15,
            textViewBottomConstraint!,
            textView.al_left == view.al_left + 21,
            textView.al_right == view.al_right - 21
        ])
        
        view.addConstraints([
            dreamTitleLabel.al_top == dateLabel.al_bottom + 27,
            dreamTitleLabel.al_left == view.al_left + 24,
            dreamTitleLabel.al_right == view.al_right - 24
        ])
        
        view.addConstraints([
            dateLabel.al_centerX == view.al_centerX,
            dateLabel.al_top == view.al_top + 24
        ])
        
        view.addConstraints([
            textViewSeparatorView.al_height == 2.0,
            textViewSeparatorView.al_left == view.al_left + 24,
            textViewSeparatorView.al_right == view.al_right - 24,
            textViewSeparatorView.al_top == dreamTitleLabel.al_bottom + 24,
        ])
        
        view.addConstraints([
            recordingLabel.al_centerX == view.al_centerX - 5.0,
            recordingLabel.al_bottom == view.al_bottom - 45.0
        ])
        
        view.addConstraints([
            redDot.al_centerY == recordingLabel.al_centerY,
            redDot.al_left == recordingLabel.al_right + 5.0,
            redDot.al_height == 18.0,
            redDot.al_width == 18.0
        ])
    }
}

protocol NewDreamViewControllerAnimatable: class {
    func shouldLeaveNewDreamViewController(_ index: Int)
}

protocol DoneButtonAdjustable: class {
    func updateDoneButton(_ state: String)
}
