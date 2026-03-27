//
//  TabBarViewModel.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//
import UIKit

// To reuse in Instructor screen
enum TabBarMode {
    case user
    case instructor
}

class TabBarViewModel {
    
    private let mode: TabBarMode
    
    init(mode: TabBarMode) {
        self.mode = mode
    }
    
    let homeTitle = "Home"
    let packageTitle = "Packages"
    let reservationTitle = "Reservations"
    let profileTitle = "Profile"
    let scheduleTitle = "Schedule"

    let homeImage = "tab-home"
    let packageImage = "tab-packages"
    let reservationImage = "tab-reservations"
    let profileImage = "tab-profile"
    let scheduleImage = "tab-schedule"
    
    
    // Used this for User and Instructor Tab Bar
    func createTabViewControllers() -> [UIViewController] {
            switch mode {
            case .user:
                return createUserTabs()
            case .instructor:
                return createInstructorTabs()
            }
        }
        
        // MARK: - User tabs
        private func createUserTabs() -> [UIViewController] {
            let homeTab = TabItem(title: homeTitle,
                                  imageName: homeImage,
                                  tag: 0,
                                  viewController: HomeViewController())
            
            let packageTab = TabItem(title: packageTitle,
                                     imageName: packageImage,
                                     tag: 1,
                                     viewController: PackageViewController())
            
            let reservationTab = TabItem(title: reservationTitle,
                                         imageName: reservationImage,
                                         tag: 2,
                                         viewController: ReservationViewController())
            
            let profileTab = TabItem(title: profileTitle,
                                     imageName: profileImage,
                                     tag: 3,
                                     viewController: ProfileViewController())
            
            return [
                makeNavController(from: homeTab),
                makeNavController(from: packageTab),
                makeNavController(from: reservationTab),
                makeNavController(from: profileTab)
            ]
        }
        
        // MARK: - Instructor tabs
        private func createInstructorTabs() -> [UIViewController] {
            let homeTab = TabItem(title: homeTitle,
                                  imageName: homeImage,
                                  tag: 0,
                                  viewController: InstructorViewController())
            
            let scheduleTab = TabItem(title: scheduleTitle,
                                         imageName: scheduleImage,
                                         tag: 1,
                                         viewController: InstructorScheduleViewController())
            
            let profileTab = TabItem(title: profileTitle,
                                     imageName: profileImage,
                                     tag: 2,
                                     viewController: ProfileViewController())
            
            return [
                makeNavController(from: homeTab),
                makeNavController(from: scheduleTab),
                makeNavController(from: profileTab)
            ]
        }
        
        // MARK: - Helper
        private func makeNavController(from tab: TabItem) -> UINavigationController {
            let nav = UINavigationController(rootViewController: tab.viewController)
            nav.tabBarItem = UITabBarItem(title: tab.title,
                                          image: UIImage(named: tab.imageName),
                                          tag: tab.tag)
            //tab.viewController.title = tab.title
            return nav
        }


//    func createTabViewControllers() -> [UIViewController] {
//        let homeTab = TabItem(title: homeTitle, 
//                              imageName: homeImage, 
//                              tag: 0, 
//                              viewController: HomeViewController())
//        
//        let packageTab = TabItem(title: packageTitle, 
//                                 imageName: packageImage, 
//                                 tag: 0, 
//                                 viewController: PackageViewController())
//        
//        let reservationTab = TabItem(title: reservationTitle, 
//                                     imageName: reservationImage, 
//                                     tag: 0, 
//                                     viewController: ReservationViewController())
//        
//        let profileTab = TabItem(title: profileTitle, 
//                                 imageName: profileImage, 
//                                 tag: 0, 
//                                 viewController: ProfileViewController())
//        
//        let homeNav = makeNavController(from: homeTab)
//        let packageNav = makeNavController(from: packageTab)
//        let reservationNav = makeNavController(from: reservationTab)
//        let profileNav = makeNavController(from: profileTab)
//        
//        return [homeNav, packageNav, reservationNav, profileNav]
//    }
//    
//    private func makeNavController(for rootViewController: UIViewController,
//                                    title: String,
//                                    systemImage: String,
//                                    tag: Int) -> UINavigationController {
//        let nav = UINavigationController(rootViewController: rootViewController)
//        
//        nav.tabBarItem = UITabBarItem(title: title, 
//                                      image: UIImage(systemName: systemImage), 
//                                      tag: tag)
//        
//        rootViewController.title = title
//        return nav
//    } 
//    
//    private func makeNavController(from tab: TabItem) -> UINavigationController {
//        let nav = UINavigationController(rootViewController: tab.viewController)
//        
//        nav.tabBarItem = UITabBarItem(title: tab.title, 
//                                      image: UIImage(named: tab.imageName), 
//                                      tag: tab.tag)
//        
//        tab.viewController.title = tab.title
//        return nav
//    }
    
}
