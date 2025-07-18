//
//  ChangePasswordViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private let mainView = ChangePasswordView()
    private let viewModel = ChangePasswordViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupActions()
        updateView()
    }
    
    private func updateView() {
        let data = viewModel.viewData
        mainView.configure(with: data)
    }
    
    private func setupActions() {
        mainView.oldPasswordButton.addTarget(self, action: #selector(oldPasswordTapped), for: .touchUpInside)
        mainView.newPasswordButton.addTarget(self, action: #selector(newPasswordTapped), for: .touchUpInside)
        mainView.confirmPasswordButton.addTarget(self, action: #selector(confirmPasswordTapped), for: .touchUpInside)
        mainView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func oldPasswordTapped() {
        mainView.highlightButton(mainView.oldPasswordButton)
        mainView.activateSubmitButton()
    }
    
    @objc private func newPasswordTapped() {
        mainView.highlightButton(mainView.newPasswordButton)
        mainView.activateSubmitButton()
    }
    
    @objc private func confirmPasswordTapped() {
        mainView.highlightButton(mainView.confirmPasswordButton)
        mainView.activateSubmitButton()
    }
    
    @objc private func submitTapped() {
        let model = ChangePasswordModel(oldPassword: "old", newPassword: "new", confirmPassword: "new")
        viewModel.submitChangePassword(model: model)
        let alert = UIAlertController(title: "Success", message: "Password updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mainView)
        
        if mainView.oldPasswordButton.frame.contains(location)
            || mainView.newPasswordButton.frame.contains(location)
            || mainView.confirmPasswordButton.frame.contains(location) {
            return
        }
        
        mainView.resetAllButtonHighlights()
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
