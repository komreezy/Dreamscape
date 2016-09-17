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
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: homeImageGrey, selectedImage: homeImageBlue)
        
        addDreamViewController = NewDreamViewController()
        addDreamViewController.tabBarItem = UITabBarItem(title: "New", image: addImageGrey, selectedImage: addImageBlue)
        
        userViewModel.delegate = homeViewController
        userProfileViewController = UserProfileCollectionViewController(userViewModel: userViewModel)
        userProfileViewController.tabBarItem = UITabBarItem(title: "User", image: profileImageGrey, selectedImage: profileImageBlue)
        
        super.init(nibName: nil, bundle: nil)
        
        delegate = self
        addDreamViewController.delegate = self
        
        view.backgroundColor = UIColor.whiteColor()
        tabBar.tintColor = UIColor.navyColor()
        
        let homeFeedNavigationController = ContainerNavigationController(rootViewController: homeViewController)
        homeFeedNavigationController.navigationBar.barTintColor = UIColor.navyColor()
        homeFeedNavigationController.navigationBar.translucent = false
        
        let tabControllers = [homeFeedNavigationController, addDreamViewController, userProfileViewController]
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
