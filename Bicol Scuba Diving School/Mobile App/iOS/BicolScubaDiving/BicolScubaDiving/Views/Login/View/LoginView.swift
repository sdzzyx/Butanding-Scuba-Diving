//
//  LoginView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

class LoginView: UIView {
    
    var onLoginTapped: ((String, String) -> Void)?
    var onForgotPasswordTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    var onGoogleSignInTapped: (() -> Void)?
    var onAppleSignInTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
    }
    
    @objc private func handleLogin() {
        let username = "username"
        let password = "password"
        onLoginTapped?(username, password)
    }
    
    @objc private func handleForgotPassword() {
        onForgotPasswordTapped?()
    }
    
    @objc private func handleSignUp() {
        onSignUpTapped?()
    }
    
    @objc private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
    
    @objc private func handleAppleSignIn() {
        onAppleSignInTapped?()
    }
}
