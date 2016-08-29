//
//  SettingsViewController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 2/4/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit
import MessageUI

enum ProfileSettingsSection: Int {
    case Account = 0
    case Actions = 1
    case About = 2
    case Logout = 3
}

class SettingsViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    MFMailComposeViewControllerDelegate,
    UIActionSheetDelegate {
    
    var appSettingView: AppSettingsView
    var closeHeaderView: SettingsCloseView
    
    var accountSettings = [
        "Name"
    ]
    
    var actionsSettings = [
        "Rate in App Store",
        "Support"
    ]
    
    var aboutSettings = [
        "FAQ",
        "Terms of Use & Privacy Policy",
        "Icon Credit"
    ]
    
    var logoutSettings = [
        "Logout"
    ]
    
    init() {
        appSettingView = AppSettingsView()
        appSettingView.translatesAutoresizingMaskIntoConstraints = false
        appSettingView.tableView.registerClass(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")
        
        closeHeaderView = SettingsCloseView()
        closeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        appSettingView.tableView.delegate = self
        appSettingView.tableView.dataSource = self
        
        closeHeaderView.closeButton.addTarget(self, action: "closeSettingsTapped", forControlEvents: .TouchUpInside)
        
        view.addSubview(closeHeaderView)
        view.addSubview(appSettingView)
        
        navigationItem.title = "settings".uppercaseString
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
        view.addConstraints([
            closeHeaderView.al_right == view.al_right,
            closeHeaderView.al_left == view.al_left,
            closeHeaderView.al_top == view.al_top,
            closeHeaderView.al_height == 60,
            
            appSettingView.al_left == view.al_left,
            appSettingView.al_top == closeHeaderView.al_bottom,
            appSettingView.al_right == view.al_right,
            appSettingView.al_bottom == view.al_bottom
        ])
    }
    
    func closeSettingsTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pushNewAboutViewController(url: String, title: String) {
        let vc = SettingsWebViewController(title: title, website: url)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: TableViewDelegate and Datasource
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let enumVal = ProfileSettingsSection(rawValue: section) else {
            return nil
        }
        
        switch enumVal {
        case .Account:
            return "Account"
        case .Actions:
            return "Actions"
        case .About:
            return "About"
        case .Logout:
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settingsSection = ProfileSettingsSection(rawValue: section) {
            switch settingsSection {
            case .Account:
                return accountSettings.count
            case .Actions:
                return actionsSettings.count
            case .About:
                return aboutSettings.count
            case .Logout:
                return logoutSettings.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let settingsSection = ProfileSettingsSection(rawValue: indexPath.section) {
            switch settingsSection {
            case .Account:
                switch indexPath.row {
                case 0:
                    tableView.deselectRowAtIndexPath(indexPath, animated: false)
                default: break
                }
                
            case .Actions:
                switch indexPath.row {
                case 0:
                    print("")
                case 1: launchEmail(self)
                default: break
                }
                
            case .About:
                var link, title: String?
                switch indexPath.row {
                case 0:
                    link = "https://getdreamscape.wordpress.com/2016/03/19/faq/"
                    title = aboutSettings[0]
                case 1:
                    link = "https://getdreamscape.wordpress.com/2016/02/25/terms-privacy-policy/"
                    title = aboutSettings[1]
                case 2:
                    link = "https://getdreamscape.wordpress.com/2016/02/26/icon-credit/"
                    title = aboutSettings[2]
                default: break
                }
                
                
                if let page = link , headerText = title {
                    pushNewAboutViewController(page, title: headerText)
                }
                
            case .Logout:
                let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
                actionSheet.showInView(view)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserProfileSettingsSectionHeaderView()
        
        if ProfileSettingsSection.Account.rawValue == section {
            headerView.titleLabel.text = "ACCOUNT"
        } else if ProfileSettingsSection.Actions.rawValue == section {
            headerView.titleLabel.text = "ACTIONS"
        } else if ProfileSettingsSection.About.rawValue == section {
            headerView.titleLabel.text = "ABOUT"
        } else if ProfileSettingsSection.Logout.rawValue == section {
            
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let settingsSection = ProfileSettingsSection(rawValue: section) else {
            return 0.01
        }
        
        switch settingsSection {
        case .About:
            return 30
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        var cell = UserProfileSettingsTableViewCell(type: .Switch)
        
        switch settingsSection {
        case .Account:
            switch indexPath.row {
            case 0:
                cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                cell.secondaryTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
                cell.userInteractionEnabled = false
            default:
                break
            }
            
            cell.titleLabel.text = accountSettings[indexPath.row]
            return cell
            
        case .Actions:
            let cell = UserProfileSettingsTableViewCell(type: .Default)
            cell.titleLabel.text = actionsSettings[indexPath.row]
            return cell
        case .About:
            let cell = UserProfileSettingsTableViewCell(type: .Default)
            cell.titleLabel.text = aboutSettings[indexPath.row]
            return cell
        case .Logout:
            let cell = UserProfileSettingsTableViewCell(type: .Logout)
            cell.titleLabel.text = logoutSettings[indexPath.row]
            return cell
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    func launchEmail(sender: AnyObject) {
        let emailTitle = "Dreamscape Feedback"
        let messageBody = ""
        let toRecipents = ["dreamscape9817234@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .CoverVertical
        presentViewController(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
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
    
    //MARK: TableViewCellDelegate
    func didFinishEditingName(newName: String) {
        
    }
    
}

