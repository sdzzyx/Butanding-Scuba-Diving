//
//  LoginViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()

    private var loginView: LoginView {
        return view as! LoginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewActions()
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = loginView
    }
    
    private func bindViewActions() {
        loginView.onLoginTapped = { [weak self] email, password in 
            self?.loginViewModel.login(username: email, password: password)
        }
        
        loginView.onForgotPasswordTapped = { [weak self] in
            self?.loginViewModel.forgotPasswordTapped()
        }
        
        loginView.onSignUpTapped = { [weak self] in
            self?.loginViewModel.signUp()
        }
        
        loginView.onGoogleSignInTapped = { [weak self] in
            guard let self = self else { return }
            
            self.loginViewModel.loginWithGoogle(from: self) { result in
                switch result {
                case .success(let user):
                    print("Success, \(user)")
                case .failure(let error): 
                    print("Error: \(error)")
                }
            }
        }
        
        loginView.onAppleSignInTapped = { [weak self] in
            self?.loginViewModel.loginWithApple(completion: { result in
                switch result {
                case .success(let user):
                    print("Success, \(user)")
                case .failure(let error): 
                    print("Error: \(error)")
                }
            })
        }
    }

}
