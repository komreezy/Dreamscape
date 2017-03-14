//
//  DreamReaderView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class DreamReaderView: UIView, UITextViewDelegate {
    var headerView: UIView
    var dreamTitle: UILabel
    var authorLabel: UILabel
    var dreamTextView: UITextView
    var currentTitle: String?
    var currentAuthor: String?
    var currentText: String?
    
    override init(frame: CGRect) {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.navyColor()
        
        dreamTitle = UILabel()
        dreamTitle.translatesAutoresizingMaskIntoConstraints = false
        dreamTitle.font = UIFont(name: "HelveticaNeue", size: 18.0)
        dreamTitle.textColor = UIColor.white
        dreamTitle.textAlignment = .center
        dreamTitle.text = currentTitle
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        authorLabel.textColor = UIColor.white
        dreamTitle.textAlignment = .center
        authorLabel.text = "by \(currentAuthor)"
        
        dreamTextView = UITextView()
        dreamTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamTextView.backgroundColor = UIColor.white
        dreamTextView.font = UIFont(name: "HelveticaNeue", size: 14.0)
        dreamTextView.isEditable = false
        dreamTextView.showsVerticalScrollIndicator = false
        dreamTextView.text = currentText
        dreamTextView.isUserInteractionEnabled = true
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        dreamTextView.delegate = self
        
        headerView.addSubview(dreamTitle)
        headerView.addSubview(authorLabel)
        addSubview(headerView)
        addSubview(dreamTextView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            headerView.al_top == al_top,
            headerView.al_left == al_left,
            headerView.al_right == al_right,
            headerView.al_height == 150,
            
            dreamTitle.al_centerX == headerView.al_centerX,
            dreamTitle.al_centerY == headerView.al_centerY - 10,
            
            authorLabel.al_centerX == dreamTitle.al_centerX,
            authorLabel.al_top == dreamTitle.al_bottom + 5,
            
            dreamTextView.al_left == al_left + 20,
            dreamTextView.al_bottom == al_bottom,
            dreamTextView.al_right == al_right - 20,
            dreamTextView.al_top == headerView.al_bottom
        ])
    }
}
