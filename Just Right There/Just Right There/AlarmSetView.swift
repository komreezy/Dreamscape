//
//  AlarmSetView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 2/27/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class AlarmSetView: UIView {

    // ask the question - what time do you usually wake up
    // take the date from the scroller in the keyboard and display
    // confirm / save button 
    
    var titleLabel: UILabel
    var dateTextField: UITextField
    var confirmButton: UIButton
    
    var timePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        titleLabel.font = UIFont(name: "Courier", size: 15.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.text = "What time do you usually \nwake up?"
        
        dateTextField = UITextField()
        dateTextField.returnKeyType = .done
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.textColor = .white
        dateTextField.font = UIFont(name: "Avenir-Book", size: 24.0)
        dateTextField.textAlignment = .center
        dateTextField.text = "08:00 AM"
        
        confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 15
        confirmButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 11.0)
        confirmButton.backgroundColor = UIColor.primaryPurple()
        confirmButton.setTitle("confirm".uppercased(), for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        
        timePicker.datePickerMode = .time
        dateTextField.inputView = timePicker
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        layer.cornerRadius = 2.0
        
        addSubview(titleLabel)
        addSubview(dateTextField)
        addSubview(confirmButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == al_top + 20
        ])
        
        addConstraints([
            dateTextField.al_centerX == al_centerX,
            dateTextField.al_centerY == al_centerY
        ])
        
        addConstraints([
            confirmButton.al_bottom == al_bottom - 20,
            confirmButton.al_centerX == al_centerX,
            confirmButton.al_height == 30,
            confirmButton.al_width == 100
        ])
    }
}
