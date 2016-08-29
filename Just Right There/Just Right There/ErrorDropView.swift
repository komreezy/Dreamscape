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
        case Username
        case Password
        case Invalid
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = WhiteColor
        textAlignment = .Center
        font = UIFont.systemFontOfSize(12.0)
        backgroundColor = UIColor.flatRed()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorText(type: ErrorType) {
        if type == .Username {
            text = "Please enter a valid username of more than 3 characters"
        } else if type == .Password {
            text = "Please enter a valid password of more than 5 characters"
        } else {
            text = "Username already in use"
        }
    }
}
