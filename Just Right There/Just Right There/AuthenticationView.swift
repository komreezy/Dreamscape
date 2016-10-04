//
//  AuthenticationView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/3/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    var emailTextField: UITextField
    var usernameTextField: UITextField
    var passwordTextField: UITextField
    var topBorderView: UIView
    var middleBorderView: UIView
    var bottomBorderView: UIView
    var finePrintLabel: UILabel
    var authenticationButton: UIButton
    var email: Bool
    
    init(email: Bool) {
        self.email = email
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Courier", size: 14.0)!,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = UIFont(name: "Courier", size: 14.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.textColor = UIColor.whiteColor()
        
        usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.font = UIFont(name: "Courier", size: 14.0)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: attributes)
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.textColor = UIColor.whiteColor()
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = UIFont(name: "Courier", size: 14.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        passwordTextField.secureTextEntry = true
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.textColor = UIColor.whiteColor()
        
        topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        middleBorderView = UIView()
        middleBorderView.translatesAutoresizingMaskIntoConstraints = false
        middleBorderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        bottomBorderView = UIView()
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.11)
        
        finePrintLabel = UILabel()
        finePrintLabel.translatesAutoresizingMaskIntoConstraints = false
        finePrintLabel.font = UIFont(name: "Courier", size: 14.0)
        finePrintLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
        finePrintLabel.textAlignment = .Center
        finePrintLabel.numberOfLines = 2
        finePrintLabel.text = "By signing up you agree to our terms\n of service & privacy policy"
        
        authenticationButton = UIButton()
        authenticationButton.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60.0)
        authenticationButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        authenticationButton.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        authenticationButton.setTitle("sign up".uppercaseString, forState: .Normal)
        authenticationButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Normal)
        authenticationButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        authenticationButton.userInteractionEnabled = false
        
        super.init(frame: CGRectZero)
        
        emailTextField.inputAccessoryView = authenticationButton
        usernameTextField.inputAccessoryView = authenticationButton
        passwordTextField.inputAccessoryView = authenticationButton
        
        emailTextField.addTarget(self, action: #selector(AuthenticationView.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        usernameTextField.addTarget(self, action: #selector(AuthenticationView.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passwordTextField.addTarget(self, action: #selector(AuthenticationView.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        backgroundColor = UIColor.blackColor()
        
        addSubview(emailTextField)
        addSubview(topBorderView)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(middleBorderView)
        addSubview(bottomBorderView)
        addSubview(finePrintLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidChange(textField: UITextField) {
        if email {
            if emailTextField.text?.isEmpty == false && usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
                authenticationButton.highlighted = true
                authenticationButton.backgroundColor = UIColor.primaryPurple()
                authenticationButton.userInteractionEnabled = true
            } else {
                authenticationButton.highlighted = false
                authenticationButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
                authenticationButton.userInteractionEnabled = false
            }
        } else {
            if usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
                authenticationButton.highlighted = true
                authenticationButton.backgroundColor = UIColor.primaryPurple()
                authenticationButton.userInteractionEnabled = true
            } else {
                authenticationButton.highlighted = false
                authenticationButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
                authenticationButton.userInteractionEnabled = false
            }
        }
    }
    
    func setupLayout() {
        addConstraints([
            emailTextField.al_left == al_left + 23.5,
            emailTextField.al_right == al_right,
            emailTextField.al_top == al_top,
            emailTextField.al_height == 60,
            
            usernameTextField.al_left == al_left + 23.5,
            usernameTextField.al_right == al_right,
            usernameTextField.al_top == emailTextField.al_bottom,
            usernameTextField.al_height == 60,
            
            passwordTextField.al_left == al_left + 23.5,
            passwordTextField.al_right == al_right,
            passwordTextField.al_top == usernameTextField.al_bottom,
            passwordTextField.al_height == 60,
            
            topBorderView.al_bottom == emailTextField.al_bottom,
            topBorderView.al_left == al_left + 25,
            topBorderView.al_right == al_right,
            topBorderView.al_height == 1,
            
            middleBorderView.al_bottom == usernameTextField.al_bottom,
            middleBorderView.al_left == al_left + 25,
            middleBorderView.al_right == al_right,
            middleBorderView.al_height == 1,
            
            bottomBorderView.al_bottom == passwordTextField.al_bottom,
            bottomBorderView.al_left == al_left + 25,
            bottomBorderView.al_right == al_right,
            bottomBorderView.al_height == 1,
            
            finePrintLabel.al_centerX == al_centerX,
            finePrintLabel.al_top == bottomBorderView.al_bottom + 30,
            finePrintLabel.al_height == 32
        ])
    }
}
