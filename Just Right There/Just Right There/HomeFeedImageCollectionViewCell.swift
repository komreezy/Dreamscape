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
    var upvoteButton: UIButton
    var downvoteButton: UIButton
    var optionsButton: UIButton
    var starLabel: UILabel
    var dateFormatter: DateFormatter
    var sendFormatter: DateFormatter
    var now: Date?
    var nowString: String?
    var sendString: String?
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
    
    var dream: Dream? {
        didSet {
            if let dream = self.dream {
                titleText = dream.title
                authorLabel.text = "by \(dream.author)"
                id = dream.id
                starLabel.text = "\(dream.upvotes - dream.downvotes)"
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingTail
                paragraphStyle.lineHeightMultiple = 20.0
                paragraphStyle.maximumLineHeight = 20.0
                paragraphStyle.minimumLineHeight = 20.0
                
                let attributes = [
                    NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!,
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
                
                previewLabel.attributedText = NSAttributedString(string: dream.text, attributes: attributes)
                dateLabel.text = dream.date
                
                if let sendDate = sendFormatter.date(from: dream.date) {
                    sendString = dateFormatter.string(from: sendDate)
                    if (sendString?.characters.count)! > 0 {
                        dateLabel.text = sendString
                    }
                }
            }
        }
    }
    
    weak var delegate: HomeFeedCellDelegate?
    
    override init(frame: CGRect) {
        
        dreamTitleLabel = UILabel()
        dreamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        dreamTitleLabel.numberOfLines = 2
        dreamTitleLabel.textColor = UIColor.white
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        authorLabel.textColor = UIColor.white
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Courier", size: 12.0)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        
        previewLabel = UILabel()
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.font = UIFont(name: "Courier", size: 16.0)
        previewLabel.numberOfLines = 4
        previewLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        
        imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.primaryPurple()
        imageView.contentEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        imageView.isUserInteractionEnabled = false
        if let picture = UserDefaults.standard.string(forKey: "picture") {
            imageView.setImage(UIImage(named: "\(picture)"), for: .normal)
        } else {
            imageView.setImage(UIImage(named: "alien-head"), for: .normal)
        }
        
        upvoteButton = UIButton()
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.setImage(UIImage(named: "upvote"), for: .normal)
        upvoteButton.setImage(UIImage(named: "upvote-highlighted"), for: .selected)
        
        downvoteButton = UIButton()
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.setImage(UIImage(named: "downvote"), for: .normal)
        downvoteButton.setImage(UIImage(named: "downvote-highlighted"), for: .selected)
        
        optionsButton = UIButton()
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.imageEdgeInsets = UIEdgeInsetsMake(8.5, 10.5, 8.5, 6.5)
        optionsButton.setImage(UIImage(named: "more"), for: .normal)
        
        starLabel = UILabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.flatGrey()
        starLabel.textAlignment = .center
        starLabel.text = "\(stars)"
        
        starLabel = UILabel()
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.textColor = UIColor.white
        starLabel.textAlignment = .center
        
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        sendFormatter = DateFormatter()
        sendFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        sendFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let upvotes = dream?.upvotes, let downvotes = dream?.downvotes {
            karma = upvotes - downvotes
        }
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        layer.cornerRadius = 2.0
        
        upvoteButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.upvoteTapped), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.downvoteTapped), for: .touchUpInside)
        optionsButton.addTarget(self, action: #selector(HomeFeedImageCollectionViewCell.displayOptions), for: .touchUpInside)
        
        addSubview(dreamTitleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(previewLabel)
        addSubview(imageView)
        addSubview(upvoteButton)
        addSubview(downvoteButton)
        addSubview(starLabel)
        addSubview(optionsButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func upvoteTapped() {
        if upvoteButton.isSelected {
            upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id,
                let upvotes = dream?.upvotes,
                let downvotes = dream?.downvotes {
                starLabel.text = "\(karma - 1)"
                
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes - 1)
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
            }
        } else {
            upvoteButton.isSelected = true
            downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id {
                if !starredIds.contains(id) {
                    starLabel.text = "\(self.karma + 1)"
                    
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
                        ] as [String : Any]
                        
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
        if downvoteButton.isSelected {
            downvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id,
                let upvotes = dream?.upvotes,
                let downvotes = dream?.upvotes {
                upvoteButton.isSelected = false
                starLabel.text = "\(karma + 1)"
                
                FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes - 1)
                FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes)
                FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
                FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").removeValue()
            }
        } else {
            downvoteButton.isSelected = true
            upvoteButton.isSelected = false
            
            if let username = UserDefaults.standard.string(forKey: "username"),
                let id = id,
                let downvotes = dream?.downvotes,
                let upvotes = dream?.upvotes {
                upvoteButton.isSelected = false
                starLabel.text = "\(karma - 1)"
                
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
                    ] as [String : Any]
                    
                    FIRDatabase.database().reference().child("feed/\(id)/downvotes").setValue(downvotes + 1)
                    FIRDatabase.database().reference().child("feed/\(id)/upvotes").setValue(upvotes)
                    FIRDatabase.database().reference().child("/users/\(username)/downvotes/\(id)").setValue(dreamDictionary)
                    FIRDatabase.database().reference().child("/users/\(username)/starred/\(id)").removeValue()
                }
            }
        }
    }
    
    func displayOptions() {
        if let title = dreamTitleLabel.text,
            let author = authorLabel.text,
            let text = previewLabel.text,
            let date = dateLabel.text,
            let id = dream?.id {
            
            delegate?.shareTapped(title, author: author, text: text, id: id, date: date)
        }
    }
    
    func setupLayout() {
        imageViewWidthConstraint = imageView.al_width == 40
        titleHeightConstraint = dreamTitleLabel.al_height == 30
        
        addConstraints([
            dreamTitleLabel.al_left == imageView.al_left,
            dreamTitleLabel.al_top == al_top + 5,
            dreamTitleLabel.al_right == al_right - 5,
            titleHeightConstraint!
        ])
        
        addConstraints([
            authorLabel.al_left == imageView.al_right + 12,
            authorLabel.al_bottom == imageView.al_centerY,
            authorLabel.al_right == al_right - 5,
            authorLabel.al_top == imageView.al_top
        ])
        
        addConstraints([
            dateLabel.al_left == authorLabel.al_left,
            dateLabel.al_top == imageView.al_centerY - 6,
            dateLabel.al_right == al_right - 5,
            dateLabel.al_bottom == imageView.al_bottom - 2
        ])
        
        addConstraints([
            previewLabel.al_right == al_right - 18,
            previewLabel.al_bottom == al_bottom - 20,
            previewLabel.al_left == imageView.al_left,
            previewLabel.al_top ==  imageView.al_bottom
        ])
        
        addConstraints([
            imageViewWidthConstraint!,
            imageView.al_left == al_left + 18,
            imageView.al_height == 40,
            imageView.al_top == dreamTitleLabel.al_bottom + 5
        ])
        
        addConstraints([
            downvoteButton.al_right == al_right - 18,
            downvoteButton.al_centerY == authorLabel.al_bottom,
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
            optionsButton.al_right == al_right - 15,
            optionsButton.al_top == al_top + 10
        ])
    }
}

protocol HomeFeedCellDelegate: class {
    func starTapped()
    func shareTapped(_ title: String, author: String, text: String, id: String, date: String)
}
