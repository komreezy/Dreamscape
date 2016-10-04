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
            if buttonState == .disabled {
                doneButton.backgroundColor = UIColor.clear
                doneButton.layer.borderWidth = 1.5
                doneButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState())
                doneButton.isUserInteractionEnabled = false
            } else {
                doneButton.backgroundColor = UIColor.primaryPurple()
                doneButton.setTitleColor(UIColor.white, for: .highlighted)
                doneButton.layer.borderWidth = 0.0
                doneButton.isUserInteractionEnabled = true
            }
        }
    }
    var delegate: ComposeAccessoryViewDelegate?
    enum ButtonState {
        case disabled
        case highlighted
    }
    
    override init(frame: CGRect) {
        secretSwitch = UISwitch()
        secretSwitch.translatesAutoresizingMaskIntoConstraints = false
        secretSwitch.onTintColor = UIColor.primaryPurple()
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                               letterSpacing: 1.0,
                               color: UIColor.white.withAlphaComponent(0.5),
                               text: "private".uppercased())
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 10.5)
        doneButton.backgroundColor = UIColor.clear
        doneButton.layer.cornerRadius = 4.0
        doneButton.layer.borderWidth = 1.5
        doneButton.isUserInteractionEnabled = false
        doneButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        doneButton.setTitle("done".uppercased(), for: UIControlState())
        doneButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState())
        
        buttonState = .disabled
        
        super.init(frame: frame)
        
        secretSwitch.addTarget(self, action: #selector(DreamInputAccessoryView.switchDidChange(_:)), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(DreamInputAccessoryView.doneButtonTapped), for: .touchUpInside)
        
        backgroundColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        addSubview(secretSwitch)
        addSubview(stateLabel)
        addSubview(doneButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            delegate?.stateDidChange("public")
            stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                                   letterSpacing: 1.0,
                                   color: UIColor.white.withAlphaComponent(0.5),
                                   text: "public".uppercased())
        } else {
            delegate?.stateDidChange("private")
            stateLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 11.5),
                                   letterSpacing: 1.0,
                                   color: UIColor.white.withAlphaComponent(0.5),
                                   text: "private".uppercased())
        }
    }
    
    func updateDoneButton(_ state: String) {
        if state == "disabled" {
            buttonState = .disabled
        } else {
            buttonState = .highlighted
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
    func stateDidChange(_ state: String)
    func doneButtonTapped()
}
