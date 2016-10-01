//
//  UserSettingView.swift
//  Lapse
//
//  Created by Kervins Valcourt on 8/26/16.
//  Copyright © 2016 tryoften. All rights reserved.
//

import UIKit

class UserSettingView: UIView {
    var navBar: UIView
    var titleLabel: UILabel
    var cancelButton: UIButton
    var ovalImageView: UIImageView
    var userImageView: UIImageView
    var nameLabel: UILabel
    var usernameLabel: UILabel
    var shareButton: UserSettingButton
    var rateAppButton: UserSettingButton
    var feedBackButton: UserSettingButton
    var supportButton: UserSettingButton
    var policyButton: UserSettingButton
    var signOutButton: UIButton
    var borderView: UIView
    var supportButtonBorderView: UIView
    
    override init(frame: CGRect) {
        navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = UIColor(hex: "#121314")
        
        borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        supportButtonBorderView = UIView()
        supportButtonBorderView.translatesAutoresizingMaskIntoConstraints = false
        supportButtonBorderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!, letterSpacing: 1.0, color: UIColor.whiteColor(), text: "settings".uppercaseString )
        titleLabel.textAlignment = .Center
        
        let attributedSignOutButton = NSAttributedString(string: "sign out".uppercaseString, attributes: [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 12.0)!,
            NSForegroundColorAttributeName: UIColor.primaryPurple()
        ])
        
        signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setAttributedTitle(attributedSignOutButton, forState: .Normal)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(13.0, 13.0, 13.0, 13.0)
        cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        
        userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.layer.cornerRadius = 45
        userImageView.contentMode = .ScaleAspectFill
        userImageView.clipsToBounds = true
        
        ovalImageView = UIImageView()
        ovalImageView.translatesAutoresizingMaskIntoConstraints = false
        ovalImageView.contentMode = .ScaleAspectFit
        ovalImageView.image = UIImage(named: "Oval")
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .Center
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .Center
        
        shareButton = UserSettingButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.settingLabel.setTextWith(UIFont(name: "Courier", size: 14)!, letterSpacing: 0.2, color: UIColor.whiteColor(), text: "Share Dreamscape with friends")
        
        rateAppButton = UserSettingButton()
        rateAppButton.translatesAutoresizingMaskIntoConstraints = false
        rateAppButton.settingLabel.setTextWith(UIFont(name: "Courier", size: 14)!, letterSpacing: 0.2, color: UIColor.whiteColor(), text: "Rate in App Store")
        
        feedBackButton = UserSettingButton()
        feedBackButton.translatesAutoresizingMaskIntoConstraints = false
        feedBackButton.settingLabel.setTextWith(UIFont(name: "Courier", size: 14)!, letterSpacing: 0.2, color: UIColor.whiteColor(), text: "Send feedback")
        
        supportButton = UserSettingButton()
        supportButton.translatesAutoresizingMaskIntoConstraints = false
        supportButton.settingLabel.setTextWith(UIFont(name: "Courier", size: 14)!, letterSpacing: 0.2, color: UIColor.whiteColor(), text: "Support")
        
        policyButton = UserSettingButton()
        policyButton.translatesAutoresizingMaskIntoConstraints = false
        policyButton.settingLabel.setTextWith(UIFont(name: "Courier", size: 14)!, letterSpacing: 0.2, color: UIColor.whiteColor(), text: "Privacy Policy")
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "#121314")
        
        addSubview(navBar)
        addSubview(borderView)
        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(userImageView)
        addSubview(ovalImageView)
        addSubview(shareButton)
        addSubview(supportButton)
        addSubview(policyButton)
        addSubview(rateAppButton)
        addSubview(feedBackButton)
        addSubview(supportButton)
        addSubview(supportButtonBorderView)
        addSubview(signOutButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            navBar.al_left == al_left,
            navBar.al_right == al_right,
            navBar.al_top == al_top,
            navBar.al_height == 70,
            
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_bottom == navBar.al_bottom - 18,
            
            borderView.al_bottom == navBar.al_bottom,
            borderView.al_left == al_left,
            borderView.al_right == al_right,
            borderView.al_height == 1,
            
            cancelButton.al_height == 40,
            cancelButton.al_width == 40,
            cancelButton.al_centerY == titleLabel.al_centerY,
            cancelButton.al_right == al_right - 10,
            
            userImageView.al_height == 90,
            userImageView.al_width == 90,
            userImageView.al_top == titleLabel.al_bottom + 46,
            userImageView.al_centerX == al_centerX,
            
            ovalImageView.al_height == 18.5,
            ovalImageView.al_width == 226,
            ovalImageView.al_bottom == shareButton.al_top - 40,
            ovalImageView.al_centerX == al_centerX,
            
            nameLabel.al_top == userImageView.al_bottom + 7.75,
            nameLabel.al_left == al_left,
            nameLabel.al_right == al_right,
            
            usernameLabel.al_top == nameLabel.al_bottom + 5.0,
            usernameLabel.al_left == al_left,
            usernameLabel.al_right == al_right,
            
            shareButton.al_top == nameLabel.al_bottom + 72,
            shareButton.al_left == al_left,
            shareButton.al_right == al_right,
            shareButton.al_height == 63,
            
            rateAppButton.al_top == shareButton.al_bottom,
            rateAppButton.al_left == al_left,
            rateAppButton.al_right == al_right,
            rateAppButton.al_height == 63,
            
            feedBackButton.al_top == rateAppButton.al_bottom,
            feedBackButton.al_left == al_left,
            feedBackButton.al_right == al_right,
            feedBackButton.al_height == 63,
            
            supportButton.al_top == feedBackButton.al_bottom,
            supportButton.al_left == al_left,
            supportButton.al_right == al_right,
            supportButton.al_height == 63,
            
            policyButton.al_top == supportButton.al_bottom,
            policyButton.al_left == al_left,
            policyButton.al_right == al_right,
            policyButton.al_height == 63,
            
            supportButtonBorderView.al_top == policyButton.al_bottom,
            supportButtonBorderView.al_left == al_left + 23.5,
            supportButtonBorderView.al_right == al_right,
            supportButtonBorderView.al_height == 0.5,
            
            signOutButton.al_left == al_left,
            signOutButton.al_right == al_right,
            signOutButton.al_bottom == al_bottom - 36
        ])
    }
}