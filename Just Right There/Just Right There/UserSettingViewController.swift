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
        userSettingView.cancelButton.addTarget(self, action: #selector(UserSettingViewController.closeUserProfile), for: .touchUpInside)
        userSettingView.signOutButton.addTarget(self, action: #selector(UserSettingViewController.logout), for: .touchUpInside)
    }
    
    func logout() {
        let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
        actionSheet.show(in: view)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("Logging out")
            UserDefaults.standard.set(false, forKey: "user")
            UserDefaults.standard.set(nil, forKey: "journals")
        default:
            print("Logging out")
            UserDefaults.standard.set(false, forKey: "user")
            UserDefaults.standard.set(nil, forKey: "journals")
        }
        
        let signInVC = SignupViewController()
        present(signInVC, animated: true, completion: nil)
    }
    
    func closeUserProfile() {
        dismiss(animated: true, completion: nil)
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
