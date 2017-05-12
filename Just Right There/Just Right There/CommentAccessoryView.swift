//
//  CommentAccessoryView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 5/9/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class CommentAccessoryView: UIView, DoneButtonAdjustable {
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
    var delegate: CommentAccessoryViewDelegate?
    enum ButtonState {
        case disabled
        case highlighted
    }
    
    override init(frame: CGRect) {
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
        
        doneButton.addTarget(self, action: #selector(DreamInputAccessoryView.doneButtonTapped), for: .touchUpInside)
        backgroundColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)

        addSubview(doneButton)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            doneButton.al_right == al_right - 18.0,
            doneButton.al_centerY == al_centerY,
            doneButton.al_height == 31.0,
            doneButton.al_width == 63.5
        ])
    }
}

protocol CommentAccessoryViewDelegate {
    func doneButtonTapped()
}
