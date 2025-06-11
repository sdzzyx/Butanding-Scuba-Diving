//
//  LoginViewModel.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

class LoginViewModel {
    
    let loginText = AppConstant.Login.loginTitle
    let emailText = AppConstant.Login.emailPlaceholder
    let passwordText = AppConstant.Login.passwordPlaceholder
    let forgotPasswordText = AppConstant.Login.forgotPasswordTitle
    let footerText = AppConstant.Login.footerText
    
    func login(username: String, password: String) {
        
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
