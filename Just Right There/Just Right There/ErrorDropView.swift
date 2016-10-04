//
//  ErrorDropView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 1/26/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class ErrorDropView: UILabel {
    enum ErrorType {
        case username
        case password
        case invalid
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = WhiteColor
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 12.0)
        backgroundColor = UIColor.flatRed()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorText(_ type: ErrorType) {
        if type == .username {
            text = "Please enter a valid username of more than 3 characters"
        } else if type == .password {
            text = "Please enter a valid password of more than 5 characters"
        } else {
            text = "Username already in use"
        }
    }
}
