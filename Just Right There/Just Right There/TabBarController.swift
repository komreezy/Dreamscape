//
//  TabBarController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 10/23/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, NewDreamViewControllerAnimatable {
    
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
        homeImageBlue = UIImage(named: "bluemoon")!
        homeImageGrey = UIImage(named: "greymoon")!
        
        addImageBlue = UIImage(named: "add-blue")!
        addImageGrey = UIImage(named: "add-grey")!
        
        profileImageBlue = UIImage(named: "bluehelmet")!
        profileImageGrey = UIImage(named: "greyhelmet")!
        
        let homeFeedViewModel = HomeFeedViewModel()
        let userViewModel = UserProfileViewModel()
        
        homeViewController = HomeFeedCollectionViewController(homeFeedViewModel: homeFeedViewModel)
        homeViewController.tabBarItem = UITabBarItem(title: "", image: homeImageGrey, selectedImage: homeImageBlue)
        
        addDreamViewController = NewDreamViewController()
        addDreamViewController.tabBarItem = UITabBarItem(title: "", image: addImageGrey, selectedImage: addImageBlue)
        
        userViewModel.delegate = homeViewController
        userProfileViewController = UserProfileCollectionViewController(userViewModel: userViewModel)
        userProfileViewController.tabBarItem = UITabBarItem(title: "", image: profileImageGrey, selectedImage: profileImageBlue)
        
        super.init(nibName: nil, bundle: nil)
        
        delegate = self
        addDreamViewController.delegate = self
        
        tabBar.tintColor = UIColor.whiteColor()
        tabBar.barTintColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        tabBar.translucent = false
        
        let homeFeedNavigationController = ContainerNavigationController(rootViewController: homeViewController)
        homeFeedNavigationController.navigationBar.barTintColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        homeFeedNavigationController.navigationBar.translucent = false
        
        let composeNavigationController = ContainerNavigationController(rootViewController: addDreamViewController)
        composeNavigationController.navigationBar.barTintColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        composeNavigationController.navigationBar.translucent = false
        
        let tabControllers = [homeFeedNavigationController, composeNavigationController, userProfileViewController]
        viewControllers = tabControllers
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldAutorotate() -> Bool {
        if selectedIndex == 2 {
            return false
        }
        return true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldLeaveNewDreamViewController(index: Int) {
        selectedIndex = index
    }
}
