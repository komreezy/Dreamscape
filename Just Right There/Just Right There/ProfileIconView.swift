//
//  ProfileIconView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 2/24/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class ProfileIconView: UIView {
    var tabBarIconImageView: UIImageView
    var currentPage: Int?
    
    override init(frame: CGRect) {
        tabBarIconImageView = UIImageView()
        tabBarIconImageView.translatesAutoresizingMaskIntoConstraints = false
        tabBarIconImageView.contentMode = .scaleAspectFit
        tabBarIconImageView.clipsToBounds = true
        tabBarIconImageView.backgroundColor = ClearColor
        
        super.init(frame: frame)
        
        backgroundColor = ClearColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tabBarIconImageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            tabBarIconImageView.al_centerY == al_centerY,
            tabBarIconImageView.al_centerX == al_centerX,
            tabBarIconImageView.al_height == 150,
            tabBarIconImageView.al_width == 150
        ])
    }
}
