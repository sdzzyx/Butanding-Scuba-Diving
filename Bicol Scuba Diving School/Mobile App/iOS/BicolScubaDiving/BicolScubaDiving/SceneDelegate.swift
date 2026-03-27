//
//  SceneDelegate.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let splashVc = SplashViewController()
        
        splashVc.completionHandler = { [weak self] in
                    DispatchQueue.main.async {
                        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                            self?.handleAuthenticationFlow(in: window)
                        } else {
                            // Go to Onboarding
                            let onboardingVc = OnboardingViewController()
                            onboardingVc.completionHandler = {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                    self?.handleAuthenticationFlow(in: window)
                                }
                            }
                            self?.setRootViewController(onboardingVc, in: window)
                        }
                    }
                }
        
        window.rootViewController = splashVc
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
    // MARK: - Authentication Check
        private func handleAuthenticationFlow(in window: UIWindow) {
            if let user = Auth.auth().currentUser {
                user.reload { [weak self] error in
                    guard error == nil else {
                        // If reload fails, send to login
                        self?.showLogin(in: window)
                        return
                    }
                    
                    if user.isEmailVerified {
                        // Fetch role from Firestore
                        FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                            DispatchQueue.main.async {
                                self?.setRootControllerForRole(role, in: window)
                            }
                        }
                    } else {
                        // Not verified → force login
                        self?.showLogin(in: window)
                    }
                }
            } else {
                // Not logged in → go to login
                showLogin(in: window)
            }
        }
    
    // Helper for smooth transitions
    private func setRootViewController(_ vc: UIViewController, in window: UIWindow) {
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    private func showLogin(in window: UIWindow) {
        let loginVc = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVc)
                setRootViewController(navController, in: window)
//        let controller = LoginViewController()
//        if let navController = self.window?.rootViewController as? UINavigationController {
//            navController.pushViewController(controller, animated: true)
//        } else {
//            // fallback: wrap in nav controller if needed
//            let navController = UINavigationController(rootViewController: controller)
//            self.window?.rootViewController = navController
//        }
    }
    
    private func setRootControllerForRole(_ role: String, in window: UIWindow) {
            switch role.lowercased() {
            case "instructor":
//                let instructorVC = InstructorViewController()
//                let nav = UINavigationController(rootViewController: instructorVC)
//                setRootViewController(nav, in: window)
                
                // Test
                let instructorTabBar = MainTabBarController(mode: .instructor)
                        setRootViewController(instructorTabBar, in: window)
            case "admin":
                // let adminVC = AdminDashboardViewController()
                // setRootViewController(adminVC, in: window)
                break
            default:
//                let tabBarVC = MainTabBarController()
//                setRootViewController(tabBarVC, in: window)
                // Test
                let userTabBar = MainTabBarController(mode: .user)
                setRootViewController(userTabBar, in: window)
            }
        }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        print("Scene opened via URL: \(url.absoluteString)")
                
                // Google Sign-In
                if GIDSignIn.sharedInstance.handle(url) {
                    return
                }
                
                // Facebook Login
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    options: [:]
                )
                
                // MARK: PayMongo GCash Return Handling
                if url.scheme == "butandingscubadiving" {
                    if url.absoluteString.contains("payment-success") {
                        print("✅ Payment success redirect detected.")
                        handlePaymentRedirect(url, success: true)
                    } else if url.absoluteString.contains("payment-failed") {
                        print("❌ Payment failed redirect detected.")
                        handlePaymentRedirect(url, success: false)
                    }
                }
            }
            
            /// Finds PaymentViewController in navigation stack and sends redirect result
            private func handlePaymentRedirect(_ url: URL, success: Bool) {
                guard let root = window?.rootViewController else { return }
                
                // Try to find PaymentViewController in any navigation stack
                if let nav = root as? UINavigationController {
                    if let paymentVC = nav.viewControllers.first(where: { $0 is PaymentViewController }) as? PaymentViewController {
                        paymentVC.handlePaymentResult(from: url)
                        return
                    }
                }
                
                // Handle case where it's inside a tab bar
                if let tabBar = root as? UITabBarController {
                    for controller in tabBar.viewControllers ?? [] {
                        if let nav = controller as? UINavigationController,
                           let paymentVC = nav.viewControllers.first(where: { $0 is PaymentViewController }) as? PaymentViewController {
                            paymentVC.handlePaymentResult(from: url)
                            return
                        }
                    }
                }
                
                // Fallback → send notification (used by your observer)
                NotificationCenter.default.post(
                    name: success ? .paymentSuccess : .paymentFailed,
                    object: nil
                )
        
        
// Old code
//        if GIDSignIn.sharedInstance.handle(url) {
//            return
//        }
//
//        ApplicationDelegate.shared.application(
//            UIApplication.shared,
//            open: url,
//            options: [:]
//        )
//        
//        // PayMongo Handle Return
//        if url.absoluteString.contains("payment-success") {
//            NotificationCenter.default.post(name: .paymentSuccess, object: nil)
//        } else if url.absoluteString.contains("payment-failed") {
//            NotificationCenter.default.post(name: .paymentFailed, object: nil)
//        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

