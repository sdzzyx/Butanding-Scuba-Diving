//
//  SignUpViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/30/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let signUpViewModel = SignUpViewModel()
    private let signUpView = SignUpView()
    
    override func loadView() {
        self.view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.configure(with: signUpViewModel.viewData)
        bindViewActions()
        navigationItem.hidesBackButton = true
    }
    
    private func bindViewActions() {
        signUpView.onSubmitTapped = { [weak self] firstName, lastName, email, phoneNumber, password, confirmPassword in
            self?.signUpViewModel.submit(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber,
                password: password,
                confirmPassword: confirmPassword
            )
        }
        
        signUpView.onBackTapped = { [weak self] in
            self?.signUpViewModel.backTapped()
            self?.navigationController?.popViewController(animated: true)
        }
        
        // ✅ Observe signup events
                signUpViewModel.onSignUpSuccess = { [weak self] role in
                    self?.navigateBasedOnRole(role)
                }
                
                signUpViewModel.onSignUpFailure = { [weak self] error in
                    self?.showError(error)
                }
                
                // Handle verification email sent
                signUpViewModel.onVerificationEmailSent = { [weak self] in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Verify Your Email",
                            message: "A verification email has been sent. Please check your inbox before logging in.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            // Navigate back to login screen
                            self?.navigationController?.popViewController(animated: true)
                        })
                        self?.present(alert, animated: true)
                    }
                }
        
        // Handle text field delegate actions through closures
        signUpView.onTextFieldDidBeginEditing = { textField in
            if let customField = textField as? CustomTextField {
                customField.layer.borderColor = UIColor.primaryBlueColor.cgColor
                customField.textColor = .primaryBlueColor
                customField.font = customField.activeFont
            }
        }
        
        signUpView.onTextFieldDidEndEditing = { textField in
            if let customField = textField as? CustomTextField {
                customField.layer.borderColor = UIColor.primaryGrayLight.cgColor
                customField.textColor = customField.inactiveTextColor
                customField.font = customField.inactiveFont
            }
        }
        
        signUpView.onTextFieldShouldReturn = { textField in
            textField.resignFirstResponder()
            return true
        }
    }
    
    // MARK: - Role-based navigation
        
        /// Centralized navigation by role. Call this after login/signup social auth flows.
        func navigateBasedOnRole(_ role: String) {
            DispatchQueue.main.async {
                switch role.lowercased() {
//                case "admin":
//                    self.navigateToAdminScreen()
                case "instructor":
                    self.navigateToInstructorScreen()
                default:
                    self.transitionToMainTab()
                }
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
    
    private func navigateToInstructorScreen() {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = scene.delegate as? SceneDelegate,
                  let window = sceneDelegate.window else {
                return
            }
            
            // Replace InstructorDashboardViewController with your actual instructor VC
            let instructorVC = InstructorViewController()
            let nav = UINavigationController(rootViewController: instructorVC)
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = nav
            })
        }
        
        // MARK: - Error Handling
        private func showError(_ error: Error) {
            let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
