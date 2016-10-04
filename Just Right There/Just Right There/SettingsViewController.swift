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
    case account = 0
    case actions = 1
    case about = 2
    case logout = 3
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
        appSettingView.tableView.register(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")
        
        closeHeaderView = SettingsCloseView()
        closeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        appSettingView.tableView.delegate = self
        appSettingView.tableView.dataSource = self
        
        closeHeaderView.closeButton.addTarget(self, action: #selector(SettingsViewController.closeSettingsTapped), for: .touchUpInside)
        
        view.addSubview(closeHeaderView)
        view.addSubview(appSettingView)
        
        navigationItem.title = "settings".uppercased()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
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
        dismiss(animated: true, completion: nil)
    }
    
    func pushNewAboutViewController(_ url: String, title: String) {
        let vc = SettingsWebViewController(title: title, website: url)
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: TableViewDelegate and Datasource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let enumVal = ProfileSettingsSection(rawValue: section) else {
            return nil
        }
        
        switch enumVal {
        case .account:
            return "Account"
        case .actions:
            return "Actions"
        case .about:
            return "About"
        case .logout:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settingsSection = ProfileSettingsSection(rawValue: section) {
            switch settingsSection {
            case .account:
                return accountSettings.count
            case .actions:
                return actionsSettings.count
            case .about:
                return aboutSettings.count
            case .logout:
                return logoutSettings.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let settingsSection = ProfileSettingsSection(rawValue: (indexPath as NSIndexPath).section) {
            switch settingsSection {
            case .account:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    tableView.deselectRow(at: indexPath, animated: false)
                default: break
                }
                
            case .actions:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    print("")
                case 1: launchEmail(self)
                default: break
                }
                
            case .about:
                var link, title: String?
                switch (indexPath as NSIndexPath).row {
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
                
                
                if let page = link , let headerText = title {
                    pushNewAboutViewController(page, title: headerText)
                }
                
            case .logout:
                let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
                actionSheet.show(in: view)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserProfileSettingsSectionHeaderView()
        
        if ProfileSettingsSection.account.rawValue == section {
            headerView.titleLabel.text = "ACCOUNT"
        } else if ProfileSettingsSection.actions.rawValue == section {
            headerView.titleLabel.text = "ACTIONS"
        } else if ProfileSettingsSection.about.rawValue == section {
            headerView.titleLabel.text = "ABOUT"
        } else if ProfileSettingsSection.logout.rawValue == section {
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let settingsSection = ProfileSettingsSection(rawValue: section) else {
            return 0.01
        }
        
        switch settingsSection {
        case .about:
            return 30
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: (indexPath as NSIndexPath).section) else {
            return UITableViewCell()
        }
        
        var cell = UserProfileSettingsTableViewCell(type: .switch)
        
        switch settingsSection {
        case .account:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell = UserProfileSettingsTableViewCell(type: .nondisclosure)
                cell.secondaryTextField.text = UserDefaults.standard.string(forKey: "username")
                cell.isUserInteractionEnabled = false
            default:
                break
            }
            
            cell.titleLabel.text = accountSettings[(indexPath as NSIndexPath).row]
            return cell
            
        case .actions:
            let cell = UserProfileSettingsTableViewCell(type: .default)
            cell.titleLabel.text = actionsSettings[(indexPath as NSIndexPath).row]
            return cell
        case .about:
            let cell = UserProfileSettingsTableViewCell(type: .default)
            cell.titleLabel.text = aboutSettings[(indexPath as NSIndexPath).row]
            return cell
        case .logout:
            let cell = UserProfileSettingsTableViewCell(type: .logout)
            cell.titleLabel.text = logoutSettings[(indexPath as NSIndexPath).row]
            return cell
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    func launchEmail(_ sender: AnyObject) {
        let emailTitle = "Dreamscape Feedback"
        let messageBody = ""
        let toRecipents = ["dreamscape9817234@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .coverVertical
        present(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
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
    
    //MARK: TableViewCellDelegate
    func didFinishEditingName(_ newName: String) {
        
    }
    
}

