//
//  SettingsWebViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SettingsWebViewController: UIViewController {
    var navigationBar: UIView
    var closeButton: UIButton
    var webView: UIWebView
    var titleBar: UILabel
    
    init(title: String, website: String) {
        navigationBar = UIView()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = BlackColor
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), for: UIControlState())
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)
        
        titleBar = UILabel()
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.font = UIFont(name: "OpenSans", size: 14)
        titleBar.text = title.uppercased()
        titleBar.backgroundColor = UIColor.clear
        titleBar.numberOfLines = 0
        titleBar.textAlignment = .center
        titleBar.textColor = WhiteColor
        
        
        let requestURL = URL(string: website)
        let request = URLRequest(url: requestURL!)
        
        webView = UIWebView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webView.loadRequest(request)
        
        super.init(nibName: nil, bundle: nil)
        
        closeButton.addTarget(self, action: #selector(SettingsWebViewController.closeTapped), for: UIControlEvents.touchUpInside)
        
        view.addSubview(webView)
        view.addSubview(navigationBar)
        navigationBar.addSubview(titleBar)
        navigationBar.addSubview(closeButton)
        
        
        setupLayout()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_top == view.al_top,
            navigationBar.al_height == 50
        ])
        
        navigationBar.addConstraints([
            titleBar.al_left == navigationBar.al_left,
            titleBar.al_right == navigationBar.al_right,
            titleBar.al_bottom == navigationBar.al_bottom,
            titleBar.al_top == navigationBar.al_top,
            
            closeButton.al_right == navigationBar.al_right - 10,
            closeButton.al_top == navigationBar.al_top + 10,
            closeButton.al_height == 30,
            closeButton.al_width == 30
        ])
    }
}
