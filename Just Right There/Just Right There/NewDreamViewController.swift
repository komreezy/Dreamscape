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
class NewDreamViewController: NewDreamVersionViewController,
SFSpeechRecognizerDelegate {
    
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
    
    var recordingLabel: UILabel
    var redDot: UIView
    
    override init() {
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
        
        super.init()
        
        firstBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        secondBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        thirdBubble.center = CGPoint(x: view.center.x + 25.0, y: view.center.y)
        
        view.addSubview(thirdBubble)
        view.addSubview(firstBubble)
        view.addSubview(secondBubble)
        view.addSubview(recordingLabel)
        view.addSubview(redDot)
        
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordButton = UIButton()
        recordButton.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        recordButton.setTitle("Record", for: UIControlState())
        recordButton.setTitleColor(UIColor.white, for: UIControlState())
        recordButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        recordButton.addTarget(self, action: #selector(NewDreamViewController.startRecording), for: .touchUpInside)
        
        let recordBarButton = UIBarButtonItem(customView: recordButton)
        
        navigationItem.rightBarButtonItem = recordBarButton
        
        recognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in }
    }
    
    func startRecording() {
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
    }
    
    func layout() {
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
