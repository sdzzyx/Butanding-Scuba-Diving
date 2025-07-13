//
//  MainTabBarController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let viewModel = TabBarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = viewModel.createTabViewControllers()
        
        tabBar.tintColor = UIColor.primaryBlueColor
    }
}
