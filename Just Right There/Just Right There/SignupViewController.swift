//
//  SignupViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 11/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
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


class SignupViewController: UIViewController, UITextFieldDelegate {
    var logoImageView: UIImageView
    var subtitleLabel: UILabel
    var signupButton: UIButton
    var loginButton: UIButton
    var needHelpButton: UIButton
    var goBackButton: UIButton
    var userDefaults: UserDefaults
    
    var emailTextField: UITextField
    var usernameTextField: UITextField
    var passwordTextField: UITextField
    var enterButton: UIButton
    
    var usernameUnderlineView: UIView
    var passwordUnderlineView: UIView
    
    var errorView: ErrorDropView
    var errorViewConstraint: NSLayoutConstraint?
    
    var state: SignupState?
    
    enum SignupState: String {
        case Login
        case Signup
    }
    
    init() {
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.numberOfLines = 2
        subtitleLabel.text = "An organized way to manage\n your dreams"
        subtitleLabel.font = UIFont(name: "Avenir-Book", size: 13.0)
        subtitleLabel.textAlignment = .center
        
        signupButton = UIButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitle("SIGN UP", for: UIControlState())
        signupButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16.0)
        signupButton.backgroundColor = UIColor.white
        signupButton.setTitleColor(UIColor.primaryDarkBlue(), for: UIControlState())
        signupButton.layer.cornerRadius = 5.0
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("LOG IN", for: UIControlState())
        loginButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16.0)
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitleColor(UIColor.primaryDarkBlue(), for: UIControlState())
        loginButton.layer.cornerRadius = 5.0
        
        goBackButton = UIButton()
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.setTitle("Go Back", for: UIControlState())
        goBackButton.setTitleColor(WhiteColor, for: UIControlState())
        goBackButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        goBackButton.alpha = 0
        goBackButton.isUserInteractionEnabled = false
        
        needHelpButton = UIButton()
        needHelpButton.translatesAutoresizingMaskIntoConstraints = false
        needHelpButton.setTitle("Need Help?", for: UIControlState())
        needHelpButton.setTitleColor(UIColor.white, for: UIControlState())
        needHelpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        userDefaults = UserDefaults.standard
        
        let usernamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.font = UIFont(name: "Avenir", size: 13.0)
        emailTextField.textColor = UIColor.primaryDarkBlue()
        emailTextField.backgroundColor = UIColor.white
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.alpha = 0.0
        emailTextField.leftView = usernamePaddingView
        emailTextField.leftViewMode = .always
        emailTextField.returnKeyType = .done
        
        usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Username"
        usernameTextField.font = UIFont(name: "Avenir", size: 13.0)
        usernameTextField.textColor = UIColor.primaryDarkBlue()
        usernameTextField.backgroundColor = UIColor.white
        usernameTextField.layer.cornerRadius = 5.0
        usernameTextField.alpha = 0.0
        usernameTextField.leftView = usernamePaddingView
        usernameTextField.leftViewMode = .always
        usernameTextField.returnKeyType = .done
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "  Password"
        passwordTextField.textColor = UIColor.primaryDarkBlue()
        passwordTextField.font = UIFont(name: "Avenir", size: 13.0)
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.layer.cornerRadius = 3.0
        passwordTextField.alpha = 0.0
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        
        enterButton = UIButton()
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Done", for: UIControlState())
        enterButton.setTitleColor(UIColor.primaryDarkBlue(), for: UIControlState())
        enterButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14.0)
        enterButton.backgroundColor = UIColor.white
        enterButton.layer.cornerRadius = 3.0
        enterButton.alpha = 0.0
        enterButton.isUserInteractionEnabled = false
        
        usernameUnderlineView = UIView()
        usernameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        usernameUnderlineView.backgroundColor = UIColor.white
        usernameUnderlineView.alpha = 0.0

        passwordUnderlineView = UIView()
        passwordUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        passwordUnderlineView.backgroundColor = UIColor.white
        passwordUnderlineView.alpha = 0.0
        
        errorView = ErrorDropView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.primaryDarkBlue()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        signupButton.addTarget(self, action: #selector(SignupViewController.showTextFields(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(SignupViewController.showTextFields(_:)), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(SignupViewController.enterButtonTapped), for: .touchUpInside)
        goBackButton.addTarget(self, action: #selector(SignupViewController.goBackButtonTapped), for: .touchUpInside)
        
        //view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(enterButton)
        view.addSubview(usernameUnderlineView)
        view.addSubview(passwordUnderlineView)
        
        view.addSubview(logoImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(signupButton)
        view.addSubview(loginButton)
        view.addSubview(goBackButton)
        view.addSubview(needHelpButton)
        
        view.addSubview(errorView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func showTextFields(_ button: UIButton) {
        enterButton.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.signupButton.alpha = 0.0
            self.loginButton.alpha = 0.0
        })
        
        view.sendSubview(toBack: signupButton)
        view.sendSubview(toBack: loginButton)
        
        UIView.animate(withDuration: 0.4, animations: {
            if button == self.signupButton {
                self.subtitleLabel.text = "Choose your username and password for \nyour Dreamscape account."
            } else {
                self.subtitleLabel.text = "Enter your username and password to login \nto your Dreamscape account."
            }
            
            self.enterButton.alpha = 1.0
            self.goBackButton.alpha = 1.0
            self.goBackButton.isUserInteractionEnabled = true
            
            self.usernameUnderlineView.alpha = 1.0
            self.usernameTextField.alpha = 1.0
            self.usernameTextField.backgroundColor = UIColor.clear
            self.usernameTextField.textColor = UIColor.white
            self.usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username",
                attributes:[NSForegroundColorAttributeName: UIColor.white])
            
            self.passwordUnderlineView.alpha = 1.0
            self.passwordTextField.alpha = 1.0
            self.passwordTextField.backgroundColor = UIColor.clear
            self.passwordTextField.textColor = UIColor.white
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                attributes:[NSForegroundColorAttributeName: UIColor.white])
        })
        
        if button.titleLabel?.text == "LOG IN" {
            enterButton.setTitle("Log In", for: UIControlState())
            state = .Login
        } else {
            enterButton.setTitle("Sign Up", for: UIControlState())
            state = .Signup
        }
    }
    
    func hideTextFields() {
        UIView.animate(withDuration: 0.4, animations: {
            self.signupButton.alpha = 1.0
            self.loginButton.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.4, animations: {
            self.enterButton.alpha = 0.0
            self.goBackButton.alpha = 0.0
            self.goBackButton.isUserInteractionEnabled = true
            
            self.usernameUnderlineView.alpha = 0.0
            self.usernameTextField.alpha = 0.0
            self.usernameTextField.backgroundColor = UIColor.clear
            self.usernameTextField.textColor = UIColor.white
            self.usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username",
                attributes:[NSForegroundColorAttributeName: UIColor.white])
            
            self.passwordUnderlineView.alpha = 0.0
            self.passwordTextField.alpha = 0.0
            self.passwordTextField.backgroundColor = UIColor.clear
            self.passwordTextField.textColor = UIColor.white
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                attributes:[NSForegroundColorAttributeName: UIColor.white])
        })
        
        enterButton.isUserInteractionEnabled = false
        state = nil
    }
    
    func showError() {
        errorViewConstraint?.constant = 25
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func goBackButtonTapped() {
        hideTextFields()
    }
    
    func enterButtonTapped() {
        if state == .Signup {
            if passwordTextField.text?.characters.count < 5 && usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.username)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            } else if usernameTextField.text?.characters.count < 3 {
                errorView.setErrorText(.username)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            } else if passwordTextField.text?.characters.count < 5 {
                errorView.setErrorText(.password)
                showError()
                delay(3.0, closure: {
                    self.hideError()
                })
            }
            
            if let username = usernameTextField.text,
                let password = passwordTextField.text {
                
                // TODO: Add email text fields
                // create Firebase user with email
                FIRAuth.auth()?.createUser(withEmail: "titty@gmail.com", password: password) { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    
                    print("createdUser")
                }
                
                userDefaults.set(true, forKey: "user")
                userDefaults.setValue("\(username)", forKey: "username")
                userDefaults.setValue("\(self.passwordTextField.text)", forKey: "password")
            
                dismiss(animated: true, completion: nil)
            }
        } else {
            if let username = usernameTextField.text,
                let password = passwordTextField.text {
                // Sign in with email firebase
                FIRAuth.auth()?.signIn(withEmail: "tity2@gmail.com", password: password, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    
                    self.userDefaults.set(true, forKey: "user")
                    self.userDefaults.setValue("\(username)", forKey: "username")
                    self.userDefaults.setValue("\(self.passwordTextField.text)", forKey: "password")
                    
                    print("sign in")
                })
                dismiss(animated: true, completion: nil)
            }
        }
        userDefaults.synchronize()
    }
    
//    func enterButtonTapped() {
//        if state == .Signup {
//            if passwordTextField.text?.characters.count < 5 && usernameTextField.text?.characters.count < 3 {
//                errorView.setErrorText(.Username)
//                showError()
//                delay(3.0, closure: {
//                    self.hideError()
//                })
//            } else if usernameTextField.text?.characters.count < 3 {
//                errorView.setErrorText(.Username)
//                showError()
//                delay(3.0, closure: {
//                    self.hideError()
//                })
//            } else if passwordTextField.text?.characters.count < 5 {
//                errorView.setErrorText(.Password)
//                showError()
//                delay(3.0, closure: {
//                    self.hideError()
//                })
//            }
//            
//            if let username = usernameTextField.text {
//                let userRef = rootRef.childByAppendingPath("users/\(username)")
//                userRef.observeEventType(.Value, withBlock: { snapshot in
//                    if !snapshot.exists() {
//                        let dreamDictionary = ["password":self.passwordTextField.text!]
//                        let userRef = rootRef.childByAppendingPath("users/\(username)")
//                        userRef.setValue(dreamDictionary)
//                        self.userDefaults.setBool(true, forKey: "user")
//                        self.userDefaults.setValue("\(username)", forKey: "username")
//                        self.userDefaults.setValue("\(self.passwordTextField.text)", forKey: "password")
//                        
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    } else {
//                        self.errorView.setErrorText(.Invalid)
//                        self.showError()
//                        self.delay(3.0, closure: {
//                            self.hideError()
//                        })
//                    }
//                    
//                    self.userDefaults.synchronize()
//                })
//            }
//        } else {
//            if let username = usernameTextField.text, let password = passwordTextField.text {
//                let userRef = rootRef.childByAppendingPath("users/\(username)")
//                userRef.observeEventType(.Value, withBlock: { snapshot in
//                    if snapshot.value != nil {
//                        if self.usernameTextField.text?.characters.count >= 3 && self.passwordTextField.text?.characters.count >= 5 {
//                            if let userData = snapshot.value as? [String:AnyObject] {
//                                if let snapPass = userData["password"]! as? String {
//                                    if snapPass == password {
//                                        self.userDefaults.setBool(true, forKey: "user")
//                                        self.userDefaults.setValue("\(username)", forKey: "username")
//                                        self.userDefaults.setValue("\(self.passwordTextField.text)", forKey: "password")
//                                        
//                                        self.dismissViewControllerAnimated(true, completion: nil)
//                                    }
//                                }
//                            }
//                        }
//                    } else {
//                        self.errorView.setErrorText(.Username)
//                        self.showError()
//                        self.delay(3.0, closure: {
//                            self.hideError()
//                        })
//                    }
//                })
//            }
//        }
//        
//        userDefaults.synchronize()
//    }
    
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
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func setupLayout() {
        errorViewConstraint = errorView.al_bottom == view.al_top
        
//        view.addConstraints([
//            logoImageView.al_top == view.al_top + 60,
//            logoImageView.al_left == view.al_left + 50,
//            logoImageView.al_right == view.al_right - 50,
//            logoImageView.al_height == 60,
//            
//            subtitleLabel.al_centerX == view.al_centerX,
//            subtitleLabel.al_top == logoImageView.al_bottom,
//            subtitleLabel.al_height == 60,
//            subtitleLabel.al_width == 300,
//            
//            signupButton.al_top == logoImageView.al_bottom + 100,
//            signupButton.al_centerX == view.al_centerX,
//            signupButton.al_width == 300,
//            signupButton.al_height == 50,
//            
//            loginButton.al_top == signupButton.al_bottom + 10,
//            loginButton.al_centerX == view.al_centerX,
//            loginButton.al_height == 50,
//            loginButton.al_width == 300
//        ])
//        
//        view.addConstraints([
//            needHelpButton.al_centerX == view.al_centerX,
//            needHelpButton.al_bottom == view.al_bottom - 15,
//            needHelpButton.al_width == 80,
//            needHelpButton.al_height == 30,
//            
//            usernameTextField.al_centerX == view.al_centerX,
//            usernameTextField.al_height == 40,
//            usernameTextField.al_width == 300,
//            usernameTextField.al_centerY == signupButton.al_centerY,
//            
//            passwordTextField.al_centerX == view.al_centerX,
//            passwordTextField.al_height == 40,
//            passwordTextField.al_width == 300,
//            passwordTextField.al_top == usernameTextField.al_bottom + 10,
//            
//            enterButton.al_centerX == view.al_centerX,
//            enterButton.al_top == passwordTextField.al_bottom + 20,
//            enterButton.al_height == 30,
//            enterButton.al_width == 140,
//            
//            goBackButton.al_centerX == view.al_centerX,
//            goBackButton.al_top == enterButton.al_bottom + 12
//        ])
//        
//        view.addConstraints([
//            usernameUnderlineView.al_centerX == view.al_centerX,
//            usernameUnderlineView.al_top == usernameTextField.al_bottom,
//            usernameUnderlineView.al_width == usernameTextField.al_width,
//            usernameUnderlineView.al_height == 1,
//            
//            passwordUnderlineView.al_centerX == view.al_centerX,
//            passwordUnderlineView.al_top == passwordTextField.al_bottom,
//            passwordUnderlineView.al_width == passwordTextField.al_width,
//            passwordUnderlineView.al_height == 1,
//            
//            errorView.al_left == view.al_left,
//            errorView.al_right == view.al_right,
//            errorViewConstraint!,
//            errorView.al_height == 25
//        ])
    }
}
