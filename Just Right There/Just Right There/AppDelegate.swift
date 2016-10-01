//
//  AppDelegate.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 8/25/15.
//  Copyright (c) 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
    UITabBarControllerDelegate {
    var window: UIWindow?
    var mainController: UITabBarController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let screen = UIScreen.mainScreen()
        let frame = screen.bounds
        
        FIRApp.configure()
        
        window = UIWindow(frame: frame)
        
        if let window = self.window {
            mainController = TabBarController()
            mainController.delegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            let composeNavigationController = ContainerNavigationController(rootViewController: NewDreamViewController())
            composeNavigationController.navigationBar.barTintColor = UIColor(red: 25.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
            composeNavigationController.navigationBar.translucent = false

            tabBarController.presentViewController(composeNavigationController, animated: true, completion: nil)

            return false
        }

        return true
    }
    
    
}