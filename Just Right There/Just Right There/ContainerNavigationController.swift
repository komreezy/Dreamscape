//
//  ContainerNavigationController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 8/10/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class ContainerNavigationController: UINavigationController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backNavImage = UIImage.imageOfBackarrow(frame: CGRectMake(0, 0, 22, 22),
                                                    color: WhiteColor,
                                                    rotate: 0,
                                                    scale: 0.5,
                                                    selected: false)
        navigationBar.translucent = false
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = UIColor.navyColor()
        navBarAppearance.tintColor = UIColor.whiteColor()
        navBarAppearance.backIndicatorImage = backNavImage
        navBarAppearance.backIndicatorTransitionMaskImage = backNavImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
