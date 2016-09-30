//
//  UserProfileHeaderView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView, UserProfileDelegate {
    
    var collapseNameLabel: UILabel
    var profileImageView: UIButton
    var nameLabel: UILabel
    var journalsLabel: UILabel
    var starredLabel: UILabel
    var karmaLabel: UILabel
    var journalsNumberLabel: UILabel
    var starredNumberLabel: UILabel
    var coverPhoto: UIImageView?
    var backgroundImage: UIImageView
    var illustrationView: UIImageView
    var nameLabelHeightConstraint: NSLayoutConstraint?
    var nameLabelHorizontalConstraint: NSLayoutConstraint?
    
    var tabContainerView: UIView
    var settingsButton: UIButton
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var highlightBarView: UIView
    var leftHighlightBarPositionConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat
    
    var userDefaults: NSUserDefaults
    weak var delegate: UserProfileHeaderDelegate?
    
    override init(frame: CGRect) {
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        collapseNameLabel = UILabel()
        collapseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collapseNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        collapseNameLabel.textColor = UIColor.whiteColor()
        collapseNameLabel.textAlignment = .Center
        collapseNameLabel.alpha = 0
        
        profileImageView = UIButton()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.backgroundColor = NavyColor
        profileImageView.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        
        backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = UIImage(named: "profile-background")
        backgroundImage.contentMode = .ScaleAspectFit
        
        illustrationView = UIImageView()
        illustrationView.translatesAutoresizingMaskIntoConstraints = false
        illustrationView.image = UIImage(named: "illustration")
        illustrationView.contentMode = .ScaleAspectFill
        
        if let picture = NSUserDefaults.standardUserDefaults().stringForKey("picture") {
            profileImageView.setImage(UIImage(named: "\(picture)"), forState: .Normal)
        } else {
            profileImageView.setImage(UIImage(named: "alien-head"), forState: .Normal)
        }
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        
        settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(named: "settingsDiamond"), forState: .Normal)
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
        
        karmaLabel = UILabel()
        karmaLabel.translatesAutoresizingMaskIntoConstraints = false
        karmaLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.54)
        karmaLabel.font = UIFont(name: "Courier", size: 13.5)
        karmaLabel.text = "334 Karma Points"
        karmaLabel.textAlignment = .Center
        
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
        favoritesTabButton.setTitle("dreams".uppercaseString, forState: .Normal)
        favoritesTabButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        favoritesTabButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.54), forState: .Selected)
        favoritesTabButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        favoritesTabButton.titleLabel?.textAlignment = .Center
        favoritesTabButton.selected = false
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("upvotes".uppercaseString, forState: .Normal)
        recentsTabButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        recentsTabButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.54), forState: .Selected)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        recentsTabButton.titleLabel?.textAlignment = .Center
        recentsTabButton.selected = true
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = UIColor.primaryPurple()
        
        offsetValue = 0.0
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        clipsToBounds = true
        
        profileImageView.addTarget(self, action: #selector(UserProfileHeaderView.profileImageTapped), forControlEvents: .TouchUpInside)
        favoritesTabButton.addTarget(self, action: #selector(UserProfileHeaderView.journalTabTapped), forControlEvents: .TouchUpInside)
        recentsTabButton.addTarget(self, action: #selector(UserProfileHeaderView.starredTabTapped), forControlEvents: .TouchUpInside)
        settingsButton.addTarget(self, action: #selector(UserProfileHeaderView.settingsTapped), forControlEvents: .TouchUpInside)
        
        addSubview(illustrationView)
        addSubview(collapseNameLabel)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(karmaLabel)
        addSubview(settingsButton)
        addSubview(backgroundImage)
        
        addSubview(tabContainerView)
        tabContainerView.addSubview(favoritesTabButton)
        tabContainerView.addSubview(recentsTabButton)
        tabContainerView.addSubview(highlightBarView)
        
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
            collapseNameLabel.alpha = 1 - progressiveness
            nameLabelHeightConstraint?.constant = (-20 * progressiveness)
            profileImageView.alpha = progressiveness
            nameLabel.alpha = progressiveness
            journalsLabel.alpha = progressiveness
            journalsNumberLabel.alpha = progressiveness
            starredLabel.alpha = progressiveness
            starredNumberLabel.alpha = progressiveness
            backgroundImage.alpha = progressiveness
        }
    }
    
    func setupLayout() {
        leftHighlightBarPositionConstraint = highlightBarView.al_left == tabContainerView.al_left
        nameLabelHeightConstraint = nameLabel.al_bottom == journalsLabel.al_top
        
        addConstraints([
            illustrationView.al_left == al_left,
            illustrationView.al_bottom == tabContainerView.al_top,
            illustrationView.al_top == al_top,
            illustrationView.al_right == al_right,
            
            collapseNameLabel.al_centerX == al_centerX,
            collapseNameLabel.al_centerY == settingsButton.al_centerY - 5,
            
            profileImageView.al_top == al_top + bounds.height * 0.32,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_height == 60,
            profileImageView.al_width == 60,
            
            backgroundImage.al_centerX == profileImageView.al_centerX,
            backgroundImage.al_centerY == profileImageView.al_centerY,
            backgroundImage.al_height == 160,
            backgroundImage.al_width == 160,
            
            nameLabel.al_centerX == al_centerX,
            nameLabel.al_top == profileImageView.al_bottom + 18,
            
            settingsButton.al_right == al_right - 15,
            settingsButton.al_top == al_top + 30,
            settingsButton.al_height == 30,
            settingsButton.al_width == 30,
            
            karmaLabel.al_centerX == al_centerX,
            karmaLabel.al_top == nameLabel.al_bottom + 7,
            
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
            leftHighlightBarPositionConstraint!
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
        recentsTabButton.selected = true
        favoritesTabButton.selected = false
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func starredTabTapped() {
        if let delegate = delegate {
            delegate.starredTabSelected()
        }
        
        leftHighlightBarPositionConstraint?.constant = tabContainerView.bounds.width / 2
        recentsTabButton.selected = false
        favoritesTabButton.selected = true
        
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
