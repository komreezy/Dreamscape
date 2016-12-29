//
//  DreamReaderUserHeaderView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/4/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class DreamReaderUserHeaderView: UIView {
    var authorLabel: UILabel
    var topDividerView: UIView
    var bottomDividerView: UIView
    var dateLabel: UILabel
    var profileImageView: UIButton
    
    override init(frame: CGRect) {
        topDividerView = UIView()
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        bottomDividerView = UIView()
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Montserrat", size: 14.0)
        authorLabel.textColor = UIColor.white
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Courier", size: 14.0)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        
        profileImageView = UIButton()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 18.0
        profileImageView.contentEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        profileImageView.isUserInteractionEnabled = false
        profileImageView.backgroundColor = UIColor.primaryPurple()
        
        super.init(frame: frame)
        
        addSubview(authorLabel)
        addSubview(profileImageView)
        addSubview(dateLabel)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            topDividerView.al_top == al_top,
            topDividerView.al_left == al_left + 24,
            topDividerView.al_right == al_right - 24,
            topDividerView.al_height == 1
        ])
        
        addConstraints([
            bottomDividerView.al_bottom == al_bottom,
            bottomDividerView.al_left == al_left + 24.0,
            bottomDividerView.al_right == al_right - 24.0,
            bottomDividerView.al_height == 1
        ])
        
        addConstraints([
            profileImageView.al_centerY == al_centerY,
            profileImageView.al_left == al_left + 24,
            profileImageView.al_height == 36,
            profileImageView.al_width == 36
        ])
        
        addConstraints([
            authorLabel.al_bottom == profileImageView.al_centerY - 1,
            authorLabel.al_left == profileImageView.al_right + 12
        ])
        
        addConstraints([
            dateLabel.al_top == profileImageView.al_centerY + 1,
            dateLabel.al_left == authorLabel.al_left
        ])
    }
}
