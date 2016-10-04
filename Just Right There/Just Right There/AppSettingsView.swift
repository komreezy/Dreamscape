//
//  AppSettingsView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 2/25/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class AppSettingsView: UIView {
    var tableView: UITableView
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = WhiteColor
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        addSubview(tableView)
        
        setupLayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            tableView.al_left == al_left,
            tableView.al_top == al_top,
            tableView.al_right == al_right,
            tableView.al_bottom == al_bottom
            ])
    }
}
