//
//  LoginViewModel.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit
import FirebaseAuth

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
    
    var onLoginSuccess: ((String) -> Void)?
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
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] result, error in
                if let error = error {
                    self?.onLoginFailure?(error)
                    return
                }
                
            guard let user = result?.user else { return }
                    
                    if user.isEmailVerified {
                        print("User logged in: \(user.uid)")
                        
                        // 🔹 Ensure Firestore user doc exists
                        FirestoreService.shared.createUserIfNeeded(user: user) { _ in
                            FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                                DispatchQueue.main.async {
                                    self?.onLoginSuccess?(role)
                                }
                            }
                        }
                    } else {
                        // ❌ Prevent access until verified
                        let verifyError = NSError(
                            domain: "Login",
                            code: -3,
                            userInfo: [NSLocalizedDescriptionKey: "Please verify your email before logging in."]
                        )
                        self?.onLoginFailure?(verifyError)
                        
                        // Send email verification again if needed
                        user.sendEmailVerification(completion: nil)
                        
                        // Force logout to block navigation
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print("Error signing out unverified user: \(error.localizedDescription)")
                        }
                    }
                }
        
        // Simulate success
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.onLoginSuccess?()
//        }
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
    
    func loginWithFacebook(from controller: UIViewController, completion: @escaping (AuthResult) -> Void) {
        SocialAuthManager.shared.signInWithFacebook(presentingVC: controller, completion: completion)
    }
    
}
