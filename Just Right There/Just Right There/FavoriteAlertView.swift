//
//  FavoriteAlertView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/25/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class FavoriteAlertView: UIView {

    var favoriteLabel: UILabel
    
    override init(frame: CGRect) {
        favoriteLabel = UILabel()
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        favoriteLabel.text = "Favorited!"
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(favoriteLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            favoriteLabel.al_centerX == al_centerX,
            favoriteLabel.al_centerY == al_centerY
        ])
    }
}
