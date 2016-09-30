//
//  DreamInputAccessoryView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 9/29/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class DreamInputAccessoryView: UIView, DoneButtonAdjustable {
    var secretSwitch: UISwitch
    var stateLabel: UILabel
    var doneButton: UIButton
    var buttonState: ButtonState {
        didSet {
            if buttonState == .Disabled {
                doneButton.backgroundColor = UIColor.clearColor()
                doneButton.layer.borderWidth = 1.5
                doneButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Normal)
                doneButton.userInteractionEnabled = false
            } else {
                doneButton.backgroundColor = UIColor.primaryPurple()
                doneButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                doneButton.layer.borderWidth = 0.0
                doneButton.userInteractionEnabled = true
            }
        }
    }
    var delegate: ComposeAccessoryViewDelegate?
    enum ButtonState {
        case Disabled
        case Highlighted
    }
    
    override init(frame: CGRect) {
        secretSwitch = UISwitch()
        secretSwitch.translatesAutoresizingMaskIntoConstraints = false
        secretSwitch.onTintColor = UIColor.primaryPurple()
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                               letterSpacing: 1.0,
                               color: UIColor.whiteColor().colorWithAlphaComponent(0.5),
                               text: "private".uppercaseString)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 10.5)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.layer.cornerRadius = 4.0
        doneButton.layer.borderWidth = 1.5
        doneButton.userInteractionEnabled = false
        doneButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        doneButton.setTitle("done".uppercaseString, forState: .Normal)
        doneButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Normal)
        
        buttonState = .Disabled
        
        super.init(frame: frame)
        
        secretSwitch.addTarget(self, action: #selector(DreamInputAccessoryView.switchDidChange(_:)), forControlEvents: .ValueChanged)
        doneButton.addTarget(self, action: #selector(DreamInputAccessoryView.doneButtonTapped), forControlEvents: .TouchUpInside)
        
        backgroundColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        addSubview(secretSwitch)
        addSubview(stateLabel)
        addSubview(doneButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchDidChange(sender: UISwitch) {
        if sender.on {
            delegate?.stateDidChange("public")
            stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                                   letterSpacing: 1.0,
                                   color: UIColor.whiteColor().colorWithAlphaComponent(0.5),
                                   text: "public".uppercaseString)
        } else {
            delegate?.stateDidChange("private")
            stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                                   letterSpacing: 1.0,
                                   color: UIColor.whiteColor().colorWithAlphaComponent(0.5),
                                   text: "private".uppercaseString)
        }
    }
    
    func updateDoneButton(state: String) {
        if state == "disabled" {
            buttonState = .Disabled
        } else {
            buttonState = .Highlighted
        }
    }
    
    func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }
    
    func setupLayout() {
        addConstraints([
            secretSwitch.al_left == al_left + 21.0,
            secretSwitch.al_centerY == al_centerY,
            
            stateLabel.al_left == secretSwitch.al_right + 12,
            stateLabel.al_centerY == al_centerY,
            
            doneButton.al_right == al_right - 18.0,
            doneButton.al_centerY == al_centerY,
            doneButton.al_height == 31.0,
            doneButton.al_width == 63.5
        ])
    }
}

protocol ComposeAccessoryViewDelegate {
    func stateDidChange(state: String)
    func doneButtonTapped()
}
