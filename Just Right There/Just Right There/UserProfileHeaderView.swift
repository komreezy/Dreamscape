//
//  UserProfileHeaderView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView, UserProfileDelegate {
    
    var profileImageView: UIButton
    var nameLabel: UILabel
    var journalsLabel: UILabel
    var starredLabel: UILabel
    var journalsNumberLabel: UILabel
    var starredNumberLabel: UILabel
    var coverPhoto: UIImageView?
    var nameLabelHeightConstraint: NSLayoutConstraint?
    var nameLabelHorizontalConstraint: NSLayoutConstraint?
    
    var tabContainerView: UIView
    var settingsButton: UIButton
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var highlightBarView: UIView
    var bottomBorderLine: UIView
    var leftHighlightBarPositionConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat
    
    var userDefaults: NSUserDefaults
    
    weak var delegate: UserProfileHeaderDelegate?
    
    override init(frame: CGRect) {
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        profileImageView = UIButton()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.backgroundColor = NavyColor
        profileImageView.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        
        if let picture = NSUserDefaults.standardUserDefaults().stringForKey("picture") {
            profileImageView.setImage(UIImage(named: "\(picture)"), forState: .Normal)
        } else {
            profileImageView.setImage(UIImage(named: "alien-head"), forState: .Normal)
        }
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.textAlignment = .Center
        
        settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(named: "settings"), forState: .Normal)
        settingsButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 10.0, 0.0)
        
        journalsLabel = UILabel()
        journalsLabel.translatesAutoresizingMaskIntoConstraints = false
        journalsLabel.font = UIFont(name: "OpenSans", size: 13.0)
        journalsLabel.textAlignment = .Center
        journalsLabel.text = "Journals"
        
        starredLabel = UILabel()
        starredLabel.translatesAutoresizingMaskIntoConstraints = false
        starredLabel.font = UIFont(name: "OpenSans", size: 13.0)
        starredLabel.textAlignment = .Center
        starredLabel.text = "Starred"
        
        journalsNumberLabel = UILabel()
        journalsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        journalsNumberLabel.font = UIFont(name: "Roboto-Bold", size: 13.0)
        journalsNumberLabel.textAlignment = .Center
        journalsNumberLabel.text = "5"
        
        starredNumberLabel = UILabel()
        starredNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        starredNumberLabel.font = UIFont(name: "Roboto-Bold", size: 13.0)
        starredNumberLabel.textAlignment = .Center
        starredNumberLabel.text = "17"
        
        tabContainerView = UIView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        favoritesTabButton = UIButton()
        favoritesTabButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesTabButton.setTitle("MY JOURNALS", forState: .Normal)
        favoritesTabButton.setTitleColor(BlackColor, forState: .Normal)
        favoritesTabButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
        favoritesTabButton.titleLabel?.textAlignment = .Center
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("STARRED", forState: .Normal)
        recentsTabButton.setTitleColor(BlackColor, forState: .Normal)
        recentsTabButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
        recentsTabButton.titleLabel?.textAlignment = .Center
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = UIColor.primaryDarkBlue()
        
        bottomBorderLine = UIView()
        bottomBorderLine.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderLine.backgroundColor = UIColor.lightGrayColor()
        
        offsetValue = 0.0
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        clipsToBounds = true

        profileImageView.addTarget(self, action: "profileImageTapped", forControlEvents: .TouchUpInside)
        favoritesTabButton.addTarget(self, action: "journalTabTapped", forControlEvents: .TouchUpInside)
        recentsTabButton.addTarget(self, action: "starredTabTapped", forControlEvents: .TouchUpInside)
        settingsButton.addTarget(self, action: "settingsTapped", forControlEvents: .TouchUpInside)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(journalsLabel)
        addSubview(journalsNumberLabel)
        addSubview(starredLabel)
        addSubview(starredNumberLabel)
        addSubview(settingsButton)
        
        addSubview(tabContainerView)
        tabContainerView.addSubview(favoritesTabButton)
        tabContainerView.addSubview(recentsTabButton)
        tabContainerView.addSubview(highlightBarView)
        tabContainerView.addSubview(bottomBorderLine)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UserScrollHeaderDelegate
    
    func userDidSelectTab(type: String) {
        if type == "favorites" {
            leftHighlightBarPositionConstraint?.constant = 0.0
        } else {
            leftHighlightBarPositionConstraint?.constant = UIScreen.mainScreen().bounds.width / 2
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            nameLabelHeightConstraint?.constant = (-20 * progressiveness)
        }
    }
    
    func setupLayout() {
        leftHighlightBarPositionConstraint = highlightBarView.al_left == tabContainerView.al_left
        nameLabelHeightConstraint = nameLabel.al_bottom == journalsLabel.al_top
        
        addConstraints([
            profileImageView.al_bottom == nameLabel.al_top - 10,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_height == 60,
            profileImageView.al_width == 60,
            
            nameLabel.al_bottom == journalsLabel.al_top - 6,
            nameLabel.al_centerX == al_centerX,
            
            settingsButton.al_right == al_right - 15,
            settingsButton.al_top == al_top + 15,
            settingsButton.al_height == 30,
            settingsButton.al_width == 30,
            
            journalsLabel.al_bottom == tabContainerView.al_top - 25,
            journalsLabel.al_right == journalsNumberLabel.al_left - 5,
            
            journalsNumberLabel.al_right == al_centerX - 5,
            journalsNumberLabel.al_bottom == journalsLabel.al_bottom,
            
            starredLabel.al_bottom == journalsLabel.al_bottom,
            starredLabel.al_left == al_centerX + 5,
            
            starredNumberLabel.al_left == starredLabel.al_right + 5,
            starredNumberLabel.al_bottom == journalsLabel.al_bottom,
            
            tabContainerView.al_bottom == al_bottom,
            tabContainerView.al_left == al_left,
            tabContainerView.al_right == al_right,
            tabContainerView.al_height == 60,
            
            favoritesTabButton.al_left == tabContainerView.al_left,
            favoritesTabButton.al_bottom == tabContainerView.al_bottom,
            favoritesTabButton.al_top == tabContainerView.al_top,
            favoritesTabButton.al_right == tabContainerView.al_centerX,
            
            recentsTabButton.al_bottom == tabContainerView.al_bottom,
            recentsTabButton.al_top == tabContainerView.al_top,
            recentsTabButton.al_right == tabContainerView.al_right,
            recentsTabButton.al_left == tabContainerView.al_centerX,
            
            highlightBarView.al_bottom == tabContainerView.al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == tabContainerView.al_width / 2,
            leftHighlightBarPositionConstraint!,
            
            bottomBorderLine.al_left == al_left,
            bottomBorderLine.al_right == al_right,
            bottomBorderLine.al_bottom == al_bottom,
            bottomBorderLine.al_height == 0.5
        ])
    }
    
    // User Profile Header Delegate
    func profileImageTapped() {
        delegate?.profileImageTapped()
    }
    
    func journalTabTapped() {
        if let delegate = delegate {
            delegate.journalTabSelected()
        }
        
        leftHighlightBarPositionConstraint?.constant = 0
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func starredTabTapped() {
        if let delegate = delegate {
            delegate.starredTabSelected()
        }
        
        leftHighlightBarPositionConstraint?.constant = tabContainerView.bounds.width / 2
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func settingsTapped() {
        delegate?.settingsSelected()
    }
    
    func numberOfItemsInSection(journals: Int, starred: Int) {
        journalsNumberLabel.text = "\(journals)"
        starredNumberLabel.text = "\(starred)"
    }
}

protocol UserProfileHeaderDelegate: class {
    func profileImageTapped()
    func journalTabSelected()
    func starredTabSelected()
    func settingsSelected()
}
