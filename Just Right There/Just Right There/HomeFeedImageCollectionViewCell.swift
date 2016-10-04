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
                dateLabel.text = dream.date
                id = dream.id
                starLabel.text = "\(dream.upvotes - dream.downvotes)"
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .ByTruncatingTail
                paragraphStyle.lineHeightMultiple = 20.0
                paragraphStyle.maximumLineHeight = 20.0
                paragraphStyle.minimumLineHeight = 20.0
                
                let attributes = [
                    NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!,
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
                
                previewLabel.attributedText = NSAttributedString(string: dream.text, attributes: attributes)
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
    
    var karma: Int = 0 {
        didSet {
            starLabel.text = "\(self.karma)"
        }
    }
    var imageViewWidthConstraint: NSLayoutConstraint?
    var titleHeightConstraint: NSLayoutConstraint?
    var upvoteButton: SpringButton
    var downvoteButton: SpringButton
    var starLabel: SpringLabel
    var titleText: String {
        set(value) {
            self.dreamTitleLabel.text = value
            if value.characters.count > 35 {
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
        previewLabel.numberOfLines = 4
        previewLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
        
        imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.primaryPurple()
        imageView.contentEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        imageView.userInteractionEnabled = false
        
        upvoteButton = SpringButton()
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.setImage(UIImage(named: "upvote"), forState: .Normal)
        upvoteButton.setImage(UIImage(named: "upvote-highlighted"), forState: .Selected)
        upvoteButton.animation = "pop"
        
        downvoteButton = SpringButton()
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.setImage(UIImage(named: "downvote"), forState: .Normal)
        downvoteButton.setImage(UIImage(named: "downvote-highlighted"), forState: .Selected)
        downvoteButton.animation = "pop"
        
        starLabel = SpringLabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .Center
        starLabel.animation = "squeeze"
        starLabel.duration = 0.5
        starLabel.text = "\(stars)"
        
        starLabel = SpringLabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.whiteColor()
        starLabel.textAlignment = .Center
        starLabel.animation = "squeeze"
        starLabel.duration = 0.5
        
        if let upvotes = dream?.upvotes, let downvotes = dream?.downvotes {
            karma = upvotes - downvotes
        }
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        layer.cornerRadius = 2.0
        upvoteButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.upvoteTapped), forControlEvents: .TouchUpInside)
        downvoteButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.downvoteTapped), forControlEvents: .TouchUpInside)
        
        addSubview(dreamTitleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(previewLabel)
        addSubview(imageView)
        addSubview(upvoteButton)
        addSubview(downvoteButton)
        addSubview(starLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func upvoteTapped() {
        if upvoteButton.selected {
            upvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id,
                let upvotes = dream?.upvotes,
                let downvotes = dream?.downvotes {
                starLabel.text = "\(karma - 1)"
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes - 1)
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
            }
        } else {
            upvoteButton.selected = true
            downvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id {
                if !starredIds.contains(id) {
                    starLabel.text = "\(self.karma + 1)"
                    starLabel.animate()
                    
                    if let title = dreamTitleLabel.text,
                        let author = authorLabel.text,
                        let text = previewLabel.text,
                        let date = dateLabel.text {
                        
                        var upvotes = 0
                        var downvotes = 0
                        
                        if let dream = dream {
                            upvotes = dream.upvotes
                            downvotes = dream.downvotes
                        }
                        
                        let dreamDictionary = [
                            "title":title,
                            "author":author,
                            "text":text,
                            "date":"\(date)",
                            "upvotes":upvotes + 1,
                            "downvotes":downvotes
                        ]
                        
                        FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes + 1)
                        FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes)
                        FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").setValue(dreamDictionary)
                        FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
                    }
                }
            }
        }
    }
    
    func downvoteTapped() {
        if downvoteButton.selected {
            downvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id,
                let upvotes = dream?.upvotes,
                let downvotes = dream?.upvotes {
                upvoteButton.selected = false
                starLabel.text = "\(karma + 1)"
                starLabel.animate()
                
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes - 1)
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
                FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
            }
        } else {
            downvoteButton.selected = true
            upvoteButton.selected = false
            
            if let username = NSUserDefaults.standardUserDefaults().stringForKey("username"),
                let id = id,
                let downvotes = dream?.downvotes,
                let upvotes = dream?.upvotes {
                upvoteButton.selected = false
                starLabel.text = "\(karma - 1)"
                starLabel.animate()
                
                if let title = dreamTitleLabel.text,
                    let author = authorLabel.text,
                    let text = previewLabel.text,
                    let date = dateLabel.text {
                    
                    let dreamDictionary = [
                        "title":title,
                        "author":author,
                        "text":text,
                        "date":"\(date)",
                        "upvotes":upvotes,
                        "downvotes":downvotes
                    ]
                    
                    FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes + 1)
                    FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes)
                    FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").setValue(dreamDictionary)
                    FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
                }
            }
        }
    }
    
    func setupLayout() {
        imageViewWidthConstraint = imageView.al_width == 40
        titleHeightConstraint = dreamTitleLabel.al_height == 30
        
        addConstraints([
            dreamTitleLabel.al_left == imageView.al_left,
            dreamTitleLabel.al_top == al_top + 5,
            dreamTitleLabel.al_right == al_right - 5,
            titleHeightConstraint!,
            
            authorLabel.al_left == imageView.al_right + 5,
            authorLabel.al_bottom == imageView.al_centerY,
            authorLabel.al_right == al_right - 5,
            authorLabel.al_top == imageView.al_top,
            
            dateLabel.al_left == imageView.al_right + 5,
            dateLabel.al_top == imageView.al_centerY - 6,
            dateLabel.al_right == al_right - 5,
            dateLabel.al_bottom == imageView.al_bottom - 2,
            
            previewLabel.al_right == al_right - 18,
            previewLabel.al_bottom == al_bottom - 20,
            previewLabel.al_left == imageView.al_left,
            previewLabel.al_top ==  imageView.al_bottom,
            
            imageViewWidthConstraint!,
            imageView.al_left == al_left + 18,
            imageView.al_height == 40,
            imageView.al_top == dreamTitleLabel.al_bottom
        ])
        
        addConstraints([
            downvoteButton.al_right == al_right - 18,
            downvoteButton.al_centerY == authorLabel.al_bottom,
            downvoteButton.al_height == 24,
            downvoteButton.al_width == 24,
            
            upvoteButton.al_right == downvoteButton.al_left - 12,
            upvoteButton.al_centerY == downvoteButton.al_centerY,
            upvoteButton.al_height == 24,
            upvoteButton.al_width == 24,
            
            starLabel.al_centerY == upvoteButton.al_centerY,
            starLabel.al_right == upvoteButton.al_left - 12,
            //starLabel.al_width == 35
        ])
    }
}

protocol HomeFeedCellDelegate: class {
    func starTapped()
}
