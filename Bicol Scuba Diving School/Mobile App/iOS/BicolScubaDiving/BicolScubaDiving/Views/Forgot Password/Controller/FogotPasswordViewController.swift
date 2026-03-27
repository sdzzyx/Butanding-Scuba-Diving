//
//  FogotPasswordViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 9/11/25.
//

import UIKit
import Foundation

class ForgotPasswordViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = ForgotPasswordViewModel()
    private let forgotPasswordView = ForgotPasswordView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        navigationItem.backButtonTitle = ""
        setupActions()
        bindViewModel()
    }
    
    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] message in
            self?.forgotPasswordView.showMessage(message, color: .systemGreen)
        }
        
        viewModel.onError = { [weak self] message in
            self?.forgotPasswordView.showMessage(message, color: .systemRed)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            self?.forgotPasswordView.showLoading(isLoading)
        }
    }
    
    // MARK: - Actions
    private func setupActions() {
        forgotPasswordView.resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
    }
    
    @objc private func didTapReset() {
        let email = forgotPasswordView.emailTextField.text ?? ""
        viewModel.sendPasswordReset(email: email)
    }
}
