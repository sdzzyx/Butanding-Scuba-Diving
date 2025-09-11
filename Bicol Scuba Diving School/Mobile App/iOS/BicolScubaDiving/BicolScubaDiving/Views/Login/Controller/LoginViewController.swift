//
//  LoginViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

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
                case .success(let user):
                    print("Success, \(user)")
                case .failure(let error): 
                    print("Error: \(error)")
                    
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
            
            self?.loginViewModel.loginWithApple(completion: { result in
                switch result {
                case .success(let user):
                    print("Success, \(user)")
                case .failure(let error): 
                    print("Error: \(error)")
                    
                    // Analytics
                    FirebaseAnalyticsManager.shared.logApiError(endpoint: "/\(AppConstant.Analytics.Endpoint.loginWithApple)",
                                                                statusCode: 0,
                                                                message: error.localizedDescription, 
                                                                screen: AppConstant.Analytics.LoginScreen.screen)
                }
            })
        }
        
        loginViewModel.onLoginSuccess = { [weak self] in
            self?.transitionToMainTab()
        }
    }
    
    // MARK: - Navigation Transition
    private func transitionToMainTab() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let tabBarVC = MainTabBarController()
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarVC
        })
    }
    
    private func navigateToSignUp() {
        let controller = SignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToForgotPassword() {
        let controller = ForgotPasswordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}
