//
//  MainTabBarController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //let viewModel = TabBarViewModel()
    
    private let viewModel: TabBarViewModel
    
    init(mode: TabBarMode) {
        self.viewModel = TabBarViewModel(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            self.viewModel = TabBarViewModel(mode: .user)
            super.init(coder: coder)
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = viewModel.createTabViewControllers()
        
        tabBar.tintColor = UIColor.primaryBlueColor
    }
}
