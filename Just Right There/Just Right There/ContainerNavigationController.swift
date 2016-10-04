//
//  ContainerNavigationController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 8/10/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class ContainerNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backNavImage = UIImage.imageOfBackarrow(frame: CGRect(x: 0, y: 0, width: 22, height: 22),
                                                    color: WhiteColor,
                                                    scale: 0.5,
                                                    selected: false,
                                                    rotate: 0)
        navigationBar.isTranslucent = false
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = UIColor.navyColor()
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.backIndicatorImage = backNavImage
        navBarAppearance.backIndicatorTransitionMaskImage = backNavImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
