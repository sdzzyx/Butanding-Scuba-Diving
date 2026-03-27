//
//  LoginViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.configure(with: loginViewModel.viewData)
        bindViewActions()
        
        // Analytics
        FirebaseAnalyticsManager.shared.logScreenView(screenName: AppConstant.Analytics.LoginScreen.screen, 
                                                      screenClass: String(describing: type(of: self)))
    }
    
    override func loadView() {
        super.loadView()
        self.view = loginView
    }
    
    private func bindViewActions() {
        loginView.bindLoginAction()
        loginView.bindFogotPasswordAction()
        loginView.bindSignUpAction()
        loginView.bindGoogleSignInAction()
        loginView.bindFacebookSignInAction()
        loginView.bindAppleSignInAction()
        
        loginView.onLoginTapped = { [weak self] email, password in 
            // Analytics
            FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click, 
                                                     parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen, 
                                                                  AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonLogin])
            
            // Execute login 
            self?.loginViewModel.login(username: email, password: password)
        }
        
        loginView.onForgotPasswordTapped = { [weak self] in
            
            self?.loginViewModel.forgotPasswordTapped()
            
            // Analytics
            FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click,
                                                     parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen,
                                                                  AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonForgotPassword])
            
            self?.navigateToForgotPassword()
        }
        
        loginView.onSignUpTapped = { [weak self] in
            // Analytics
            FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click,
                                                     parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen,
                                                                  AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonSignUp])
            
            self?.navigateToSignUp()
        }
        
        loginView.onGoogleSignInTapped = { [weak self] in
            guard let self = self else { return }
            
            // Analytics
            FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click,
                                                     parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen,
                                                                  AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonGoogle])
            
            self.loginViewModel.loginWithGoogle(from: self) { result in
                switch result {
                case .success(let authResult):
                    if let user = Auth.auth().currentUser {
                        FirestoreService.shared.createUserIfNeeded(user: user) { _ in
                            FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                                switch role {
//                                case "admin":
//                                    self.navigateToAdminScreen()
                                case "instructor":
                                    self.navigateToInstructorScreen()
                                default:
                                    self.transitionToMainTab()
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.showErrorAlert(message: "Error occurred during Google Sign In")
                    
                    // Analytics
                    FirebaseAnalyticsManager.shared.logApiError(endpoint: "/\(AppConstant.Analytics.Endpoint.loginWithGoogle)",
                                                                statusCode: 0,
                                                                message: error.localizedDescription,
                                                                screen: AppConstant.Analytics.LoginScreen.screen)
                }
            }
        }
        
        loginView.onAppleSignInTapped = { [weak self] in
            // Analytics
            FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click,
                                                     parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen,
                                                                  AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonApple])
            
            
            self?.loginViewModel.loginWithApple { result in
                switch result {
                case .success(let authResult):
                    if let user = Auth.auth().currentUser {
                        FirestoreService.shared.createUserIfNeeded(user: user) { _ in
                            FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                                DispatchQueue.main.async {
                                    self?.navigateBasedOnRole(role)
                                }
//                                switch role {
////                                case "admin":
////                                    self.navigateToAdminScreen()
//                                case "instructor":
//                                    self?.navigateToInstructorScreen()
//                                default:
//                                    self?.transitionToMainTab()
//                                }
                            }
                        }
                    }
                case .failure(let error):
                    self?.showErrorAlert(message: "Error occurred during Apple Sign In")
                    
                    // Analytics
                    FirebaseAnalyticsManager.shared.logApiError(endpoint: "/\(AppConstant.Analytics.Endpoint.loginWithApple)",
                                                                statusCode: 0,
                                                                message: error.localizedDescription,
                                                                screen: AppConstant.Analytics.LoginScreen.screen)
                }
            }
        }
        
        loginView.onFacebookSignInTapped = { [weak self] in
            guard let self = self else { return }

                // Analytics
                FirebaseAnalyticsManager.shared.logEvent(
                    name: AppConstant.Analytics.EventName.click,
                    parameters: [
                        AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.LoginScreen.screen,
                        AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.LoginScreen.buttonFacebook
                    ])

                self.loginViewModel.loginWithFacebook(from: self) { result in
                    switch result {
                    case .success(let user):
                        FirestoreService.shared.createUserIfNeeded(user: user) { _ in
                            FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                                DispatchQueue.main.async {
                                    self.navigateBasedOnRole(role)
                                }
                            }
                        }
                    case .failure(let error):
                        self.showErrorAlert(message: "Error occurred during Facebook Sign In")

                        // Analytics
                        FirebaseAnalyticsManager.shared.logApiError(
                            endpoint: "/\(AppConstant.Analytics.Endpoint.loginWithFacebook)",
                            statusCode: 0,
                            message: error.localizedDescription,
                            screen: AppConstant.Analytics.LoginScreen.screen
                        )
                    }
                }
        }
        
        loginViewModel.onLoginSuccess = { [weak self] role in
            self?.navigateBasedOnRole(role)
        }
        
        loginViewModel.onLoginFailure = { [weak self] error in
            self?.showErrorAlert(message: error.localizedDescription)
            /*self?.showErrorAlert(message: "Error occurred during login, email or password is incorrect")*/     // Stay on login screen, show error
        }
    }
    
    // MARK: - Navigation Transition
    private func transitionToMainTab() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let tabBarVC = MainTabBarController(mode: .user)
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarVC
        })
    }
    
//    private func navigateToInstructorScreen() {
//        let controller = InstructorViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
    
    private func navigateToSignUp() {
        let controller = SignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToForgotPassword() {
        let controller = ForgotPasswordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Alerts
        private func showSuccessAlert(message: String) {
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    

}

extension LoginViewController {
    func navigateBasedOnRole(_ role: String) {
        switch role {
        case "admin":
            navigateToAdminScreen()
        case "instructor":
            navigateToInstructorScreen()
        default:
            transitionToMainTab()
        }
    }
    
    private func navigateToAdminScreen() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
//        let adminVC = AdminDashboardViewController() // Replace with your admin screen
//        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = UINavigationController(rootViewController: adminVC)
//        })
    }
    
    private func navigateToInstructorScreen() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
//        let instructorVC = InstructorViewController() // Replace with your instructor screen
//        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = UINavigationController(rootViewController: instructorVC)
//        })
        // Test
        let instructorTabBar = MainTabBarController(mode: .instructor)
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = instructorTabBar
                })
    }
}
