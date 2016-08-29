//
//  UserProfileSettingsSectionHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 10/18/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSettingsSectionHeaderView: UIView {
    var titleLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 11)
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 10,
            titleLabel.al_bottom == al_bottom - 15
        ])
    }
}