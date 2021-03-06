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
    var alarmButton: UIButton
    var favoritesTabButton: UIButton
    var recentsTabButton: UIButton
    var highlightBarView: UIView
    var leftHighlightBarPositionConstraint: NSLayoutConstraint?
    var offsetValue: CGFloat
    var userDefaults: UserDefaults
    weak var delegate: UserProfileHeaderDelegate?
    
    override init(frame: CGRect) {
        userDefaults = UserDefaults.standard
        
        collapseNameLabel = UILabel()
        collapseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collapseNameLabel.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        collapseNameLabel.textColor = UIColor.white
        collapseNameLabel.textAlignment = .center
        collapseNameLabel.alpha = 0
        
        profileImageView = UIButton()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.backgroundColor = UIColor.primaryPurple()
        profileImageView.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        
        backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = UIImage(named: "profile-background")
        backgroundImage.contentMode = .scaleAspectFit
        
        illustrationView = UIImageView()
        illustrationView.translatesAutoresizingMaskIntoConstraints = false
        illustrationView.image = UIImage(named: "illustration")
        illustrationView.contentMode = .scaleAspectFill
        
        if let picture = UserDefaults.standard.string(forKey: "picture") {
            profileImageView.setImage(UIImage(named: "\(picture)"), for: UIControlState())
        } else {
            profileImageView.setImage(UIImage(named: "alien-head"), for: UIControlState())
        }
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        
        settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(named: "settingsDiamond"), for: UIControlState())
        settingsButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 10.0, 0.0)
        
        alarmButton = UIButton()
        alarmButton.translatesAutoresizingMaskIntoConstraints = false
        alarmButton.setImage(UIImage(named: "alarm"), for: UIControlState())
        alarmButton.contentEdgeInsets = UIEdgeInsetsMake(0.5, 10.5, 10.5, 0.5)
        
        journalsLabel = UILabel()
        journalsLabel.translatesAutoresizingMaskIntoConstraints = false
        journalsLabel.textAlignment = .center
        journalsLabel.setTextWith(UIFont(name: "Montserrat", size: 13.0), letterSpacing: 0.5, color: UIColor.white.withAlphaComponent(0.54), text: "Journals")
        
        starredLabel = UILabel()
        starredLabel.translatesAutoresizingMaskIntoConstraints = false
        starredLabel.textAlignment = .center
        starredLabel.setTextWith(UIFont(name: "Montserrat", size: 13.0), letterSpacing: 0.5, color: UIColor.white.withAlphaComponent(0.54), text: "Starred")
        
        karmaLabel = UILabel()
        karmaLabel.translatesAutoresizingMaskIntoConstraints = false
        karmaLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        karmaLabel.font = UIFont(name: "Courier", size: 13.5)
        karmaLabel.text = "334 Karma Points"
        karmaLabel.textAlignment = .center
        
        journalsNumberLabel = UILabel()
        journalsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        journalsNumberLabel.font = UIFont(name: "Courier-Bold", size: 13.0)
        journalsNumberLabel.textAlignment = .center
        journalsNumberLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        journalsNumberLabel.text = "5"
        
        starredNumberLabel = UILabel()
        starredNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        starredNumberLabel.font = UIFont(name: "Courier-Bold", size: 13.0)
        starredNumberLabel.textAlignment = .center
        starredNumberLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        starredNumberLabel.text = "17"
        
        tabContainerView = UIView()
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        favoritesTabButton = UIButton()
        favoritesTabButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesTabButton.setTitle("dreams".uppercased(), for: UIControlState())
        favoritesTabButton.setTitleColor(UIColor.white, for: UIControlState())
        favoritesTabButton.setTitleColor(UIColor.white.withAlphaComponent(0.54), for: .selected)
        favoritesTabButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        favoritesTabButton.titleLabel?.textAlignment = .center
        favoritesTabButton.isSelected = false
        
        recentsTabButton = UIButton()
        recentsTabButton.translatesAutoresizingMaskIntoConstraints = false
        recentsTabButton.setTitle("upvotes".uppercased(), for: UIControlState())
        recentsTabButton.setTitleColor(UIColor.white, for: UIControlState())
        recentsTabButton.setTitleColor(UIColor.white.withAlphaComponent(0.54), for: .selected)
        recentsTabButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        recentsTabButton.titleLabel?.textAlignment = .center
        recentsTabButton.isSelected = true
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = UIColor.primaryPurple()
        
        offsetValue = 0.0
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        clipsToBounds = true
        
        profileImageView.addTarget(self, action: #selector(UserProfileHeaderView.profileImageTapped), for: .touchUpInside)
        favoritesTabButton.addTarget(self, action: #selector(UserProfileHeaderView.journalTabTapped), for: .touchUpInside)
        recentsTabButton.addTarget(self, action: #selector(UserProfileHeaderView.starredTabTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(UserProfileHeaderView.settingsTapped), for: .touchUpInside)
        alarmButton.addTarget(self, action: #selector(UserProfileHeaderView.alarmTapped), for: .touchUpInside)
        
        addSubview(illustrationView)
        addSubview(collapseNameLabel)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(journalsLabel)
        addSubview(journalsNumberLabel)
        addSubview(starredLabel)
        addSubview(starredNumberLabel)
        addSubview(settingsButton)
        addSubview(alarmButton)
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
    
    func userDidSelectTab(_ type: String) {
        if type == "favorites" {
            leftHighlightBarPositionConstraint?.constant = 0.0
        } else {
            leftHighlightBarPositionConstraint?.constant = UIScreen.main.bounds.width / 2
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
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
            illustrationView.al_right == al_right
        ])
        
        addConstraints([
            collapseNameLabel.al_centerX == al_centerX,
            collapseNameLabel.al_centerY == settingsButton.al_centerY - 5
        ])
        
        addConstraints([
            profileImageView.al_top == al_top + bounds.height * 0.32,
            profileImageView.al_centerX == al_centerX,
            profileImageView.al_height == 60,
            profileImageView.al_width == 60
        ])
        
        addConstraints([
            backgroundImage.al_centerX == profileImageView.al_centerX,
            backgroundImage.al_centerY == profileImageView.al_centerY,
            backgroundImage.al_height == 160,
            backgroundImage.al_width == 160
        ])
        
        addConstraints([
            nameLabel.al_centerX == al_centerX,
            nameLabel.al_top == profileImageView.al_bottom + 18
        ])
        
        addConstraints([
            settingsButton.al_right == al_right - 15,
            settingsButton.al_top == al_top + 30,
            settingsButton.al_height == 30,
            settingsButton.al_width == 30
        ])
        
        addConstraints([
            alarmButton.al_left == al_left + 10,
            alarmButton.al_top == al_top + 30,
            alarmButton.al_height == 30,
            alarmButton.al_width == 30
        ])
        
        addConstraints([
            journalsLabel.al_top == nameLabel.al_bottom + 5,
            journalsLabel.al_right == journalsNumberLabel.al_left - 5
        ])
        
        addConstraints([
            journalsNumberLabel.al_right == nameLabel.al_centerX - 4,
            journalsNumberLabel.al_bottom == journalsLabel.al_bottom
        ])
        
        addConstraints([
            starredLabel.al_bottom == journalsLabel.al_bottom,
            starredLabel.al_left == nameLabel.al_centerX + 6
        ])
        
        addConstraints([
            starredNumberLabel.al_left == starredLabel.al_right + 5,
            starredNumberLabel.al_bottom == journalsLabel.al_bottom
        ])
        
        addConstraints([
            tabContainerView.al_bottom == al_bottom,
            tabContainerView.al_left == al_left,
            tabContainerView.al_right == al_right,
            tabContainerView.al_height == 60
        ])
        
        addConstraints([
            favoritesTabButton.al_left == tabContainerView.al_left,
            favoritesTabButton.al_bottom == tabContainerView.al_bottom,
            favoritesTabButton.al_top == tabContainerView.al_top,
            favoritesTabButton.al_right == tabContainerView.al_centerX
        ])
        
        addConstraints([
            recentsTabButton.al_bottom == tabContainerView.al_bottom,
            recentsTabButton.al_top == tabContainerView.al_top,
            recentsTabButton.al_right == tabContainerView.al_right,
            recentsTabButton.al_left == tabContainerView.al_centerX
        ])
        
        addConstraints([
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
        recentsTabButton.isSelected = true
        favoritesTabButton.isSelected = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) 
    }
    
    func starredTabTapped() {
        if let delegate = delegate {
            delegate.starredTabSelected()
        }
        
        leftHighlightBarPositionConstraint?.constant = tabContainerView.bounds.width / 2
        recentsTabButton.isSelected = false
        favoritesTabButton.isSelected = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) 
    }
    
    func settingsTapped() {
        delegate?.settingsSelected()
    }
    
    func alarmTapped() {
        delegate?.alarmSelected()
    }
    
    func numberOfItemsInSection(_ journals: Int, starred: Int) {
        journalsNumberLabel.text = "\(journals)"
        starredNumberLabel.text = "\(starred)"
    }
}

protocol UserProfileHeaderDelegate: class {
    func profileImageTapped()
    func journalTabSelected()
    func starredTabSelected()
    func settingsSelected()
    func alarmSelected()
}
