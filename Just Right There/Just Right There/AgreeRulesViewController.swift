//
//  AgreeRulesViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 3/9/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class AgreeRulesViewController: UIViewController {
    var headerView: UIView
    var agreeButton: UIButton
    var cancelButton: UIButton
    var titleLabel: UILabel
    var textView: UITextView
    
    let rules = "\nThis is an app designed to share entertaining dreams and stories. \n\n"
                + "Please DO NOT share abusive dreams or bully people through the stories you share. "
                + "We do not tolerate any abusive behaviour on this app. "
                + "This includes but is not limited to defaming, abusing, harassing, stalking, and threatening others. \n\n"
                + "Please DO NOT post other people's phone numbers, street addresses, social media accounts, personally identifiable information or content that is lewd, obscene or offensive. \n\n"
                + "Also, please DO NOT post repetitive, spammy content. \n\n"
                + "If your stories or dreams are repeatedly flagged, you will be suspended."
    
    init() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.navyColor()
        
        agreeButton = UIButton()
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.setTitle("Agree", for: UIControlState())
        agreeButton.setTitleColor(WhiteColor, for: UIControlState())
        agreeButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.setTitleColor(WhiteColor, for: UIControlState())
        cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16.0)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Roboto", size: 20.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = "Rules"
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 19.0)
        textView.text = rules
        
        super.init(nibName: nil, bundle: nil)
        
        agreeButton.addTarget(self, action: #selector(AgreeRulesViewController.agreeButtonSelected), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(AgreeRulesViewController.cancelButtonSelected), for: .touchUpInside)
        
        headerView.addSubview(agreeButton)
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(textView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func agreeButtonSelected() {
        UserDefaults.standard.set(true, forKey: "agreed")
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            headerView.al_top == view.al_top,
            headerView.al_left == view.al_left,
            headerView.al_right == view.al_right,
            headerView.al_height == 65,
        ])
        
        view.addConstraints([
            agreeButton.al_right == view.al_right - 15,
            agreeButton.al_centerY == headerView.al_centerY + 2,
            agreeButton.al_width == 55,
            agreeButton.al_height == 35
        ])
        
        view.addConstraints([
            cancelButton.al_left == view.al_left + 15,
            cancelButton.al_centerY == headerView.al_centerY + 2,
            cancelButton.al_width == 55,
            cancelButton.al_height == 35
        ])
        
        view.addConstraints([
            titleLabel.al_centerX == headerView.al_centerX,
            titleLabel.al_centerY == headerView.al_centerY
        ])
        
        view.addConstraints([
            textView.al_left == view.al_left + 20,
            textView.al_bottom == view.al_bottom,
            textView.al_right == view.al_right - 20,
            textView.al_top == headerView.al_bottom
        ])
    }
}
