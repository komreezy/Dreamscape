//
//  ContainerNavigationController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 8/10/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit

class ContainerNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.translucent = false
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = UIColor.primaryDarkBlue()
        navBarAppearance.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
