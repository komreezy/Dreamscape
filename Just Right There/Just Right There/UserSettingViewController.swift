//
//  UserSettingViewController.swift
//  Lapse
//
//  Created by Kervins Valcourt on 8/29/16.
//  Copyright © 2016 tryoften. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController, UIActionSheetDelegate {
    var userSettingView: UserSettingView
    
    init() {
        userSettingView = UserSettingView()
        userSettingView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(userSettingView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSettingView.cancelButton.addTarget(self, action: #selector(UserSettingViewController.closeUserProfile), forControlEvents: .TouchUpInside)
        userSettingView.signOutButton.addTarget(self, action: #selector(UserSettingViewController.logout), forControlEvents: .TouchUpInside)
    }
    
    func logout() {
        let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
        actionSheet.showInView(view)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("Logging out")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "user")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "journals")
        default:
            print("Logging out")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "user")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "journals")
        }
        
        let signInVC = SignupViewController()
        presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func closeUserProfile() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            userSettingView.al_left == view.al_left,
            userSettingView.al_right == view.al_right,
            userSettingView.al_top == view.al_top,
            userSettingView.al_bottom == view.al_bottom,
        ])
    }
}
