//
//  AuthenticationViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/3/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    var navigationBar: UIView
    var authenticationView: AuthenticationView
    var email: Bool
    var errorView: ErrorDropView
    var errorViewConstraint: NSLayoutConstraint?
    var userDefaults: NSUserDefaults
    var state: SignupState?
    var delegate: AuthenticationObservable?
    
    enum SignupState: String {
        case Login
        case Signup
    }
    
    init(email: Bool) {
        self.email = email
        
        authenticationView = AuthenticationView(email: email)
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar = UIView()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        errorView = ErrorDropView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        authenticationView.emailTextField.delegate = self
        authenticationView.usernameTextField.delegate = self
        authenticationView.passwordTextField.delegate = self
        
        authenticationView.authenticationButton.addTarget(self, action: #selector(AuthenticationViewController.enterButtonTapped), forControlEvents: .TouchUpInside)
        
        view.addSubview(authenticationView)
        view.addSubview(navigationBar)
        view.addSubview(errorView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let titleViewLabel = UILabel(frame: CGRectMake(0,0,50,30))
        if email {
            titleViewLabel.text = "sign up".uppercaseString
        } else {
            titleViewLabel.text = "sign in".uppercaseString
        }
    
        titleViewLabel.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        titleViewLabel.textAlignment = .Center
        titleViewLabel.textColor = UIColor.whiteColor()
        
//        let cancelButton = UIButton(frame: CGRectMake(0,0,50,25))
//        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
//        cancelButton.titleLabel?.textAlignment = .Right
//        cancelButton.setTitle("Cancel", forState: .Normal)
//        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        
//        let rightBarButton = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.titleView = titleViewLabel
        //navigationItem.rightBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enterButtonTapped() {
        if state == .Signup {
            if authenticationView.passwordTextField.text?.characters.count < 5 && authenticationView.usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.Username)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            } else if authenticationView.usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.Username)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            } else if authenticationView.passwordTextField.text?.characters.count < 5 {
                errorView.setErrorText(.Password)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            }
            
            if let username = authenticationView.usernameTextField.text,
                let password = authenticationView.passwordTextField.text,
                let email = authenticationView.emailTextField.text {
                
                // create Firebase user with email
                FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        print("createdUser")
                    }
                }
                
                FIRDatabase.database().reference().child("users/\(username)").setValue([
                    "email":email
                ])
                
                userDefaults.setBool(true, forKey: "user")
                userDefaults.setValue("\(username)", forKey: "username")
                userDefaults.setValue("\(self.authenticationView.passwordTextField.text)", forKey: "password")
                
                delegate?.didSignUpSuccessfully()
                //navigationController?.popViewControllerAnimated(true)
                //dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            if let username = authenticationView.usernameTextField.text,
                let password = authenticationView.passwordTextField.text,
                let email = authenticationView.emailTextField.text {
                // Sign in with email firebase
                FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        let trimmedUsername = username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        let trimmedEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        FIRDatabase.database().reference().child("users/\(trimmedUsername)/email").observeSingleEventOfType(.Value,
                            withBlock: { snapshot in
                                if trimmedEmail == snapshot.value as? String {
                                    self.userDefaults.setBool(true, forKey: "user")
                                    self.userDefaults.setValue("\(trimmedUsername)", forKey: "username")
                                    self.userDefaults.setValue("\(self.authenticationView.passwordTextField.text)", forKey: "password")
                                    
                                    print("sign in")
                                    self.delegate?.didSignUpSuccessfully()
                                }
                        })
                    }
                })
                //navigationController?.popViewControllerAnimated(true)
                //dismissViewControllerAnimated(true, completion: nil)
            }
        }
        userDefaults.synchronize()
    }
    
    func showError() {
        errorViewConstraint?.constant = 25
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func hideError() {
        errorViewConstraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupLayout() {
        errorViewConstraint = errorView.al_bottom == view.al_top
        
        view.addConstraints([
            authenticationView.al_left == view.al_left,
            authenticationView.al_right == view.al_right,
            authenticationView.al_top == view.al_top,
            authenticationView.al_bottom == view.al_bottom,
            
            errorView.al_left == view.al_left,
            errorView.al_right == view.al_right,
            errorViewConstraint!,
            errorView.al_height == 25
        ])
    }
}

protocol AuthenticationObservable {
    func didSignUpSuccessfully()
}
