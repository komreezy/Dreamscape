//
//  SettingsCloseView.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 2/4/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class SettingsCloseView: UIView {
    var closeButton: UIButton
    var borderView: UIView
    var titleLabel: UILabel
    
    override init(frame: CGRect) {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), for: UIControlState())
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)
        
        borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.lightGray
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = WhiteColor
        titleLabel.text = "SETTINGS"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        addSubview(closeButton)
        addSubview(borderView)
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            closeButton.al_right == al_right - 20,
            closeButton.al_centerY == al_centerY,
            closeButton.al_height == 30,
            closeButton.al_width == 30
        ])
        
        addConstraints([
            borderView.al_left == al_left,
            borderView.al_right == al_right,
            borderView.al_bottom == al_bottom,
            borderView.al_height == 1
        ])
        
        addConstraints([
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_centerY == al_centerY
        ])
    }
}
