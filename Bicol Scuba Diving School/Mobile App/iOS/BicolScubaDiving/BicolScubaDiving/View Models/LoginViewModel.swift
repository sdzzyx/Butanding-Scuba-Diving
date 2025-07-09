//
//  LoginViewModel.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

/// A view-specific data model used to configure the UI elements of `LoginView`
struct LoginViewData {
    let logoImage: UIImage?
    let emailPlaceholder: String
    let passwordPlaceholder: String
    let loginButtonTitle: String
    let forgotButtonTitle: String
    let googleButtonImage: UIImage?
    let appleButtonImage: UIImage?
    let facebookButtonImage: UIImage?
    let footerText: String
    let footerTextHighlights: [String]
}

class LoginViewModel {
    
    let loginText = AppConstant.Login.loginTitle
    let emailText = AppConstant.Login.emailPlaceholder
    let passwordText = AppConstant.Login.passwordPlaceholder
    let forgotPasswordText = AppConstant.Login.forgotPasswordTitle
    let footerText = AppConstant.Login.footerText
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((Error) -> Void)?
    
    var viewData: LoginViewData {
        return LoginViewData(
            logoImage: UIImage(named: "logo"), 
            emailPlaceholder: "Email", 
            passwordPlaceholder: "Password", 
            loginButtonTitle: "Login", 
            forgotButtonTitle: "Forgot Password?", 
            googleButtonImage: UIImage(named: "google_button")?.withRenderingMode(.alwaysOriginal), 
            appleButtonImage: UIImage(named: "apple_button")?.withRenderingMode(.alwaysOriginal),
            facebookButtonImage: UIImage(named: "facebook_button")?.withRenderingMode(.alwaysOriginal),
            footerText: "Don't have an account? Sign Up",
            footerTextHighlights: ["Sign Up"])
    }
    
    func login(username: String, password: String) {
        // TODO: Add logic here
        
        // Simulate success
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.onLoginSuccess?()
        }
    }
    
    func forgotPasswordTapped() {
        
    }
    
    func signUp() {
        
    }
    
    func loginWithGoogle(from controller: UIViewController, completion: @escaping (AuthResult) -> Void) {
        SocialAuthManager.shared.signInWithGoogle(presentingVC: controller, completion: completion)
    }
    
    func loginWithApple(completion: @escaping (AuthResult) -> Void) {
        SocialAuthManager.shared.signInWithApple(completion: completion)
    }
    
}
