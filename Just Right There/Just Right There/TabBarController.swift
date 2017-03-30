//
//  TabBarController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class TabBarController: UITabBarController,
    UITabBarControllerDelegate,
    NewDreamViewControllerAnimatable {
    fileprivate let dummyTabBar: UIView
    fileprivate let imageView: UIImageView
    var homeImageBlue: UIImage
    var homeImageGrey: UIImage
    var addImageBlue: UIImage
    var addImageGrey: UIImage
    var profileImageBlue: UIImage
    var profileImageGrey: UIImage
    var homeViewController: HomeFeedCollectionViewController
    var addDreamViewController: NewDreamViewController
    var userProfileViewController: UserProfileCollectionViewController
    
    init() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "tabBarLip")
        imageView.contentMode = .scaleAspectFit

        dummyTabBar = UIView()
        dummyTabBar.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        dummyTabBar.layer.shadowOpacity = 0.8
        dummyTabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        dummyTabBar.layer.shadowColor = UIColor.black.cgColor
        dummyTabBar.layer.shadowRadius = 4

        homeImageBlue = UIImage(named: "bluemoon")!
        homeImageGrey = UIImage(named: "greymoon")!
        
        addImageBlue = UIImage(named: "add-blue")!
        addImageGrey = UIImage(named: "add-grey")!
        
        profileImageBlue = UIImage(named: "profile")!
        profileImageGrey = UIImage(named: "profile")!
        
        let homeFeedViewModel = HomeFeedViewModel()
        let userViewModel = UserProfileViewModel()
        
        homeViewController = HomeFeedCollectionViewController(homeFeedViewModel: homeFeedViewModel)
        homeViewController.tabBarItem = UITabBarItem(title: "", image: homeImageGrey, selectedImage: homeImageBlue)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5.0, 25.0, -5.0, -25.0)
        
        addDreamViewController = NewDreamViewController()
        addDreamViewController.tabBarItem = UITabBarItem(title: "", image: addImageGrey.withRenderingMode(.alwaysOriginal), selectedImage: addImageBlue)
        
        userViewModel.delegate = homeViewController
        userProfileViewController = UserProfileCollectionViewController(userViewModel: userViewModel)
        userProfileViewController.tabBarItem = UITabBarItem(title: "", image: profileImageGrey, selectedImage: profileImageBlue)
        userProfileViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5.0, -25.0, -5.0, 25.0)
        
        super.init(nibName: nil, bundle: nil)
        
        delegate = self
        addDreamViewController.delegate = self

        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        tabBar.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false

        dummyTabBar.frame = tabBar.frame

        let homeFeedNavigationController = ContainerNavigationController(rootViewController: homeViewController)
        homeFeedNavigationController.navigationBar.barTintColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        homeFeedNavigationController.navigationBar.isTranslucent = false
        
        let composeNavigationController = ContainerNavigationController(rootViewController: addDreamViewController)
        composeNavigationController.navigationBar.barTintColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        composeNavigationController.navigationBar.isTranslucent = false

        view.insertSubview(imageView, belowSubview: tabBar)
        view.insertSubview(dummyTabBar, belowSubview: imageView)

        let tabControllers = [homeFeedNavigationController, composeNavigationController, userProfileViewController] as [UIViewController]
        viewControllers = tabControllers

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate : Bool {
        if selectedIndex == 2 {
            return false
        }
        return true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(TabBarController.updateHiddenTabBar), name: NSNotification.Name(rawValue: "updateTabBar"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateHiddenTabBar() {
        tabBar.isHidden = tabBar.isHidden ? false : true
        imageView.isHidden = imageView.isHidden ? false : true
        dummyTabBar.isHidden = dummyTabBar.isHidden ? false : true
    }
    
    func shouldLeaveNewDreamViewController(_ index: Int) {
        selectedIndex = index
    }
    
    func setupLayout() {
        view.addConstraints([
            imageView.al_centerX == tabBar.al_centerX,
            imageView.al_centerY == tabBar.al_centerY - 5,
            imageView.al_height == 75,
            imageView.al_width == 75
        ])
    }
}
