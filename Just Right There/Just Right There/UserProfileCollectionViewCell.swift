//
//  UserProfileCollectionViewCell.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    var title: String = ""
    var author: String = ""
    var text: String = ""
    var id: String = ""
    
    var titleLabel: UILabel
    var dateLabel: UILabel
    var shareButton: UIButton
    var highlightLine: UIView
    weak var delegate: UserProfileCellDelegate?
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        titleLabel.text = "Dream Title"
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "OpenSans", size: 9.0)
        dateLabel.textColor = UIColor.flatGrey()
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.setImage(UIImage(named: "share"), for: UIControlState())
        shareButton.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        
        highlightLine = UIView()
        highlightLine.translatesAutoresizingMaskIntoConstraints = false
        highlightLine.backgroundColor = UIColor.lightGray
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        shareButton.addTarget(self, action: #selector(UserProfileCollectionViewCell.shareTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(highlightLine)
        addSubview(shareButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shareTapped() {
        delegate?.shareTapped(title, author: author, text: text, id: id, date: dateLabel.text!)
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == al_left + 10,
            titleLabel.al_bottom == al_centerY,
            titleLabel.al_right == shareButton.al_left - 10
        ])
        
        addConstraints([
            dateLabel.al_left == titleLabel.al_left,
            dateLabel.al_top == al_centerY
        ])
        
        addConstraints([
            highlightLine.al_bottom == al_bottom,
            highlightLine.al_left == al_left,
            highlightLine.al_right == al_right,
            highlightLine.al_height == 0.5
        ])
        
        addConstraints([
            shareButton.al_right == al_right - 10,
            shareButton.al_centerY == al_centerY,
            shareButton.al_height == 30,
            shareButton.al_width == 30
        ])
    }
}

protocol UserProfileCellDelegate: class {
    func shareTapped(_ title: String, author: String, text: String, id: String, date: String)
}
