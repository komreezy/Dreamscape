//
//  HomeFeedImageCollectionViewCell.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeFeedImageCollectionViewCell: UICollectionViewCell {
    var dream: Dream? {
        didSet {
            if let dream = self.dream {
                titleText = dream.title
                authorLabel.text = "by \(dream.author)"
                previewLabel.text = dream.text
                dateLabel.text = dream.date
                id = dream.id
                stars = dream.stars
            }
        }
    }
    var dreamTitleLabel: UILabel
    var authorLabel: UILabel
    var dateLabel: UILabel
    var previewLabel: UILabel
    var imageView: UIButton
    var starred: Bool = false
    var id: String?
    var stars: Int? {
        didSet {
            if self.stars != nil {
                starLabel.text = "\(self.stars!)"
            } else {
                starLabel.text = "0"
            }
        }
    }
    var imageViewWidthConstraint: NSLayoutConstraint?
    var titleHeightConstraint: NSLayoutConstraint?
    var starButton: SpringButton
    var starLabel: SpringLabel
    var titleText: String {
        set(value) {
            self.dreamTitleLabel.text = value
            if value.characters.count > 40 {
                titleHeightConstraint?.constant = 50
            } else {
                titleHeightConstraint?.constant = 30
            }
        }
        
        get {
            return self.titleText
        }
    }
    weak var delegate: HomeFeedCellDelegate?
    
    override init(frame: CGRect) {
        
        dreamTitleLabel = UILabel()
        dreamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        dreamTitleLabel.numberOfLines = 2
        dreamTitleLabel.textColor = UIColor.whiteColor()
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        authorLabel.textColor = UIColor.whiteColor()
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Courier", size: 12.0)
        dateLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.54)
        
        previewLabel = UILabel()
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.font = UIFont(name: "Courier", size: 16.0)
        previewLabel.numberOfLines = 5
        previewLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
        
        imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = NavyColor
        imageView.contentEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        imageView.userInteractionEnabled = false
        imageView.backgroundColor = NavyColor
        
        starButton = SpringButton()
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.setImage(UIImage(named: "greystar"), forState: .Normal)
        starButton.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        starButton.animation = "pop"
        
        starLabel = SpringLabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.text = "\(stars)"
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .Center
        starLabel.animation = "squeeze"
        starLabel.duration = 0.5
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        layer.cornerRadius = 2.0
        starButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.starTapped), forControlEvents: .TouchUpInside)
        
        addSubview(dreamTitleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(previewLabel)
        addSubview(imageView)
        addSubview(starButton)
        addSubview(starLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func starTapped() {
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"), let id = id, let stars = stars {
            if !starredIds.contains(id) {
                starButton.animate()
                starButton.setImage(UIImage(named: "goldstar"), forState: .Normal)
                starLabel.text = "\(stars + 1)"
                starLabel.textColor = UIColor.flatGold()
                starLabel.animate()
                
                if let title = dreamTitleLabel.text,
                    let author = authorLabel.text,
                    let text = previewLabel.text,
                    let date = dateLabel.text {
                        let dreamDictionary = ["title":title, "author":author, "text":text, "date":"\(date)", "stars":stars + 1]
                        FIRDatabase.database().reference().child("feed/\(id)/stars").setValue(stars + 1)
                        FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").setValue(dreamDictionary)
                    }
            } else {
                starButton.animate()
                starButton.setImage(UIImage(named: "greystar"), forState: .Normal)
                starLabel.text = "\(stars - 1)"
                starLabel.textColor = UIColor.grayColor()
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/stars").setValue(stars - 1)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
            }
        }
    }
    
    func setupLayout() {
        imageViewWidthConstraint = imageView.al_width == 40
        titleHeightConstraint = dreamTitleLabel.al_height == 30
        
        addConstraints([
            dreamTitleLabel.al_left == imageView.al_left,
            dreamTitleLabel.al_top == al_top + 5,
            dreamTitleLabel.al_right == al_right - 80,
            titleHeightConstraint!,
            
            authorLabel.al_left == imageView.al_right + 5,
            authorLabel.al_bottom == imageView.al_centerY,
            authorLabel.al_right == al_right - 5,
            authorLabel.al_top == imageView.al_top,
            
            dateLabel.al_left == imageView.al_right + 5,
            dateLabel.al_top == imageView.al_centerY - 6,
            dateLabel.al_right == al_right - 5,
            dateLabel.al_bottom == imageView.al_bottom - 2,
            
            previewLabel.al_right == al_right - 10,
            previewLabel.al_bottom == al_bottom - 20,
            previewLabel.al_left == imageView.al_left,
            previewLabel.al_top ==  imageView.al_bottom,
            
            imageViewWidthConstraint!,
            imageView.al_left == al_left + 10,
            imageView.al_height == 40,
            imageView.al_top == dreamTitleLabel.al_bottom,
            
            starButton.al_centerX == al_right - 40,
            starButton.al_height == 30,
            starButton.al_width == 30,
            starButton.al_centerY == dreamTitleLabel.al_top + 25,
            
            starLabel.al_centerX == starButton.al_centerX,
            starLabel.al_top == starButton.al_bottom
        ])
    }
}

protocol HomeFeedCellDelegate: class {
    func starTapped()
}
