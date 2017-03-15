//
//  AuthenticationViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/3/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    var navigationBar: UIView
    var authenticationView: AuthenticationView
    var email: Bool
    var errorView: ErrorDropView
    var errorViewConstraint: NSLayoutConstraint?
    var userDefaults: UserDefaults
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
        
        userDefaults = UserDefaults.standard
        
        errorView = ErrorDropView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        authenticationView.emailTextField.delegate = self
        authenticationView.usernameTextField.delegate = self
        authenticationView.passwordTextField.delegate = self
        
        authenticationView.authenticationButton.addTarget(self, action: #selector(AuthenticationViewController.enterButtonTapped), for: .touchUpInside)
        
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
    
        let titleViewLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 30))
        if email {
            titleViewLabel.text = "sign up".uppercased()
        } else {
            titleViewLabel.text = "sign in".uppercased()
        }
    
        titleViewLabel.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        titleViewLabel.textAlignment = .center
        titleViewLabel.textColor = UIColor.white
        
        navigationItem.titleView = titleViewLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enterButtonTapped() {
        if state == .Signup {
            if authenticationView.passwordTextField.text?.characters.count < 5 && authenticationView.usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.username)
                showError()
                delay(delay: 3.0, closure: {
                    self.hideError()
                })
            } else if authenticationView.usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.username)
                showError()
                delay(delay: 3.0, closure: {
                    self.hideError()
                })
            } else if authenticationView.passwordTextField.text?.characters.count < 5 {
                errorView.setErrorText(.password)
                showError()
                delay(delay: 3.0, closure: {
                    self.hideError()
                })
            }
            
            if let username = authenticationView.usernameTextField.text,
                let password = authenticationView.passwordTextField.text,
                let email = authenticationView.emailTextField.text {
                
                // create Firebase user with email
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        print("createdUser")
                    }
                }
                
                FIRDatabase.database().reference().child("users/\(username)").setValue([
                    "email":email
                ])
                
                userDefaults.set(true, forKey: "user")
                userDefaults.setValue("\(username)", forKey: "username")
                userDefaults.setValue("\(self.authenticationView.passwordTextField.text)", forKey: "password")
                
                delegate?.didSignUpSuccessfully()
            }
        } else {
            if let username = authenticationView.usernameTextField.text,
                let password = authenticationView.passwordTextField.text,
                let email = authenticationView.emailTextField.text {
                // Sign in with email firebase
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
                        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
                        FIRDatabase.database().reference().child("users/\(trimmedUsername)/email").observeSingleEvent(of: .value,
                                                                                                                      with: { snapshot in
                                if trimmedEmail == snapshot.value as? String {
                                    self.userDefaults.set(true, forKey: "user")
                                    self.userDefaults.setValue("\(trimmedUsername)", forKey: "username")
                                    self.userDefaults.setValue("\(self.authenticationView.passwordTextField.text)", forKey: "password")
                                    
                                    print("sign in")
                                    self.delegate?.didSignUpSuccessfully()
                                    return
                                }
                        })
                    }
                })
                
                FIRDatabase.database().reference().child("users/\(username)").observeSingleEvent(of: .value,
                                                                                                 with: { snapshot in
                    if snapshot.value != nil {
                        if username.characters.count >= 3 && password.characters.count >= 5 {
                            if let userData = snapshot.value as? [String:AnyObject] {
                                if let snapPass = userData["password"] as? String {
                                    if snapPass == password {
                                        self.userDefaults.set(true, forKey: "user")
                                        self.userDefaults.setValue("\(username)", forKey: "username")
                                        
                                        FIRDatabase.database().reference().child("users/\(username)/email").setValue(email)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    } else {
                        self.errorView.setErrorText(.username)
                        self.showError()
                        
                        delay(delay: 3.0, closure: {
                            self.hideError()
                        })
                    }
                })
            }
        }
        userDefaults.synchronize()
    }
    
    func showError() {
        errorViewConstraint?.constant = 25
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func hideError() {
        errorViewConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupLayout() {
        errorViewConstraint = errorView.al_bottom == view.al_top
        
        view.addConstraints([
            authenticationView.al_left == view.al_left,
            authenticationView.al_right == view.al_right,
            authenticationView.al_top == view.al_top,
            authenticationView.al_bottom == view.al_bottom
        ])
        
        view.addConstraints([
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
