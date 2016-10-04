//
//  LandingPageViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/2/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController, AuthenticationObservable {
    var image1 = UIImageView(image: UIImage(named: "landing4"))
    var image2 = UIImageView(image: UIImage(named: "landing3"))
    var image3 = UIImageView(image: UIImage(named: "landing2"))
    var image4 = UIImageView(image: UIImage(named: "landing1"))

    var titleView: UILabel
    var subtitleLabel: UILabel
    var signupButton: UIButton
    var loginButton: UIButton
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var viewController: AuthenticationViewController
    
    init() {
        image1.frame = CGRect(x: -(screenWidth * 0.37)*2, y: -(screenHeight * 0.25)*2, width: screenWidth * 0.37, height: screenHeight * 0.25)
        image2.frame = CGRect(x: -(screenWidth * 0.37)*2, y: -(screenHeight * 0.25)*2, width: screenWidth * 0.37, height: screenHeight * 0.25)
        image3.frame = CGRect(x: -(screenWidth * 0.37)*2, y: -(screenHeight * 0.25)*2, width: screenWidth * 0.37, height: screenHeight * 0.25)
        image4.frame = CGRect(x: -(screenWidth * 0.37)*2, y: -(screenHeight * 0.25)*2, width: screenWidth * 0.37, height: screenHeight * 0.25)
        
        let titleAttributes = [
            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 22.0)!,
            NSKernAttributeName: NSNumber(value: 1.0 as Float)
        ]
        
        titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.textAlignment = .center
        titleView.textColor = UIColor.white
        titleView.attributedText = NSAttributedString(string: "Dreamscape", attributes: titleAttributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 21.0
        paragraphStyle.maximumLineHeight = 21.0
        paragraphStyle.minimumLineHeight = 21.0
        
        let subtitleAttributes = [
            NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!,
            NSParagraphStyleAttributeName: paragraphStyle,
        ]
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "Courier", size: 14.0)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        subtitleLabel.text = "Share your dreams anonymously\n or save them to read later"
        
        signupButton = UIButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = UIColor(fromHexString: "000000")
        signupButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 11.5)
        signupButton.layer.cornerRadius = 26.5
        signupButton.setTitle("sign up".uppercased(), for: UIControlState())
        signupButton.setTitleColor(UIColor.white, for: UIControlState())
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 11.5)
        loginButton.backgroundColor = UIColor.clear
        loginButton.setTitle("login".uppercased(), for: UIControlState())
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        
        viewController = AuthenticationViewController(email: false)
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        signupButton.addTarget(self, action: #selector(LandingPageViewController.buttonDidTap(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(LandingPageViewController.buttonDidTap(_:)), for: .touchUpInside)
        
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(titleView)
        view.addSubview(subtitleLabel)
        view.addSubview(signupButton)
        view.addSubview(loginButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "sign up".uppercased() {
            viewController = AuthenticationViewController(email: true)
            viewController.delegate = self
            viewController.state = .Signup
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.barTintColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController = AuthenticationViewController(email: false)
            viewController.delegate = self
            viewController.state = .Login
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.barTintColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func animateImageViews() {
        for i in 0...3 {
            switch i {
            case 0:
                delay(delay: 0.125, closure: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.image1.frame.origin.x = (self.screenWidth * 0.25) + (CGFloat(i) * 15)
                        self.image1.frame.origin.y = (self.screenHeight * 0.19) + (CGFloat(i) * 15)
                    })
                })
            case 1:
                delay(delay: 0.25, closure: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.image2.frame.origin.x = (self.screenWidth * 0.25) + (CGFloat(i) * 15)
                        self.image2.frame.origin.y = (self.screenHeight * 0.19) + (CGFloat(i) * 15)
                    })
                })
            case 2:
                delay(delay: 0.375, closure: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.image3.frame.origin.x = (self.screenWidth * 0.25) + (CGFloat(i) * 15)
                        self.image3.frame.origin.y = (self.screenHeight * 0.19) + (CGFloat(i) * 15)
                    })
                })
            case 3:
                delay(delay: 0.5, closure: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.image4.frame.origin.x = (self.screenWidth * 0.25) + (CGFloat(i) * 15)
                        self.image4.frame.origin.y = (self.screenHeight * 0.19) + (CGFloat(i) * 15)
                    })
                })
            default:
                return
            }
        }
    }
    
    func didSignUpSuccessfully() {
        viewController.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            titleView.al_centerX == view.al_centerX,
            titleView.al_bottom == subtitleLabel.al_top - 20
        ])
        
        view.addConstraints([
            subtitleLabel.al_centerX == view.al_centerX,
            subtitleLabel.al_left == view.al_left + 47.5,
            subtitleLabel.al_right == view.al_right - 47.5,
            subtitleLabel.al_bottom == signupButton.al_top - 30,
            subtitleLabel.al_height == 42
        ])
        
        view.addConstraints([
            signupButton.al_left == view.al_left + 40.5,
            signupButton.al_right == view.al_right - 40.5,
            signupButton.al_height == 52,
            signupButton.al_bottom == loginButton.al_top - 20
        ])
        
        view.addConstraints([
            loginButton.al_centerX == view.al_centerX,
            loginButton.al_bottom == view.al_bottom - 40
        ])
    }
}
