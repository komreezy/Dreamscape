//
//  DreamReaderHeaderView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/4/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class DreamReaderHeaderView: UIView {
    var dreamTitle: UILabel
    var profileView: DreamReaderUserHeaderView
    var upvoteButton: UIButton
    var downvoteButton: UIButton
    var starLabel: UILabel
    
    override init(frame: CGRect) {
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "Montserrat", size: 22.0)
        dreamTitle.textColor = UIColor.white
        dreamTitle.textAlignment = .left
        dreamTitle.numberOfLines = 2
        
        profileView = DreamReaderUserHeaderView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        upvoteButton = UIButton()
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.setImage(UIImage(named: "upvote"), for: UIControlState())
        upvoteButton.setImage(UIImage(named: "upvote-highlighted"), for: .selected)
        
        downvoteButton = UIButton()
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.setImage(UIImage(named: "downvote"), for: UIControlState())
        downvoteButton.setImage(UIImage(named: "downvote-highlighted"), for: .selected)
        
        starLabel = UILabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.white
        starLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        addSubview(dreamTitle)
        addSubview(profileView)
        addSubview(upvoteButton)
        addSubview(downvoteButton)
        addSubview(starLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            dreamTitle.al_top == al_top + 30,
            dreamTitle.al_left == al_left + 24,
            dreamTitle.al_right == starLabel.al_left - 5
        ])
        
        addConstraints([
            downvoteButton.al_right == al_right - 24,
            downvoteButton.al_centerY == dreamTitle.al_centerY,
            downvoteButton.al_height == 24,
            downvoteButton.al_width == 24
        ])
        
        addConstraints([
            upvoteButton.al_right == downvoteButton.al_left - 12,
            upvoteButton.al_centerY == downvoteButton.al_centerY,
            upvoteButton.al_height == 24,
            upvoteButton.al_width == 24
        ])
        
        addConstraints([
            starLabel.al_centerY == upvoteButton.al_centerY,
            starLabel.al_right == upvoteButton.al_left - 12
        ])
        
        addConstraints([
            profileView.al_top == dreamTitle.al_bottom + 24,
            profileView.al_left == al_left,
            profileView.al_right == al_right,
            profileView.al_bottom == al_bottom
        ])
    }
}
