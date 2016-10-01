//
//  UserSettingButton.swift
//  Lapse
//
//  Created by Kervins Valcourt on 8/29/16.
//  Copyright © 2016 tryoften. All rights reserved.
//

import UIKit

class UserSettingButton: UIButton {
    var settingLabel: UILabel
    var arrowImageView: UIImageView
    var borderView: UIView
    
    override init(frame: CGRect) {
        settingLabel = UILabel()
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "disclosure")
        
        super.init(frame: frame)
        
        addSubview(settingLabel)
        addSubview(arrowImageView)
        addSubview(borderView)
        
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            settingLabel.al_left == al_left + 23.5,
            settingLabel.al_centerY == al_centerY,
            settingLabel.al_right == al_right,
            
            borderView.al_top == al_top,
            borderView.al_left == al_left + 23.5,
            borderView.al_right == al_right,
            borderView.al_height == 0.5,
            
            arrowImageView.al_height == 17,
            arrowImageView.al_width == 12,
            arrowImageView.al_centerY == al_centerY,
            arrowImageView.al_right == al_right - 20
        ])
    }
}
