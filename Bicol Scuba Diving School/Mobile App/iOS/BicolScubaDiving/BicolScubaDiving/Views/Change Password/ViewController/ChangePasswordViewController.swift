//
//  ChangePasswordViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/5/25.
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
        // TextField Editing Handlers
        mainView.oldPasswordField.addTarget(self, action: #selector(oldPasswordTapped), for: .editingDidBegin)
        mainView.newPasswordField.addTarget(self, action: #selector(newPasswordTapped), for: .editingDidBegin)
        mainView.confirmPasswordField.addTarget(self, action: #selector(confirmPasswordTapped), for: .editingDidBegin)
        
        mainView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        mainView.oldPasswordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.newPasswordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.confirmPasswordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        // Dismiss keyboard and reset highlights
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tapGesture)
    }
    
    private func validateFields() {
        let isOldFilled = !(mainView.oldPasswordField.text ?? "").isEmpty
        let isNewFilled = !(mainView.newPasswordField.text ?? "").isEmpty
        let isConfirmFilled = !(mainView.confirmPasswordField.text ?? "").isEmpty
        
        if isOldFilled && isNewFilled && isConfirmFilled {
            mainView.activateSubmitButton()
        } else {
            mainView.submitButton.isEnabled = false
            mainView.submitButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    @objc private func oldPasswordTapped() {
        mainView.highlightButton(mainView.oldPasswordField)
        mainView.activateSubmitButton()
    }
    
    @objc private func newPasswordTapped() {
        mainView.highlightButton(mainView.newPasswordField)
        mainView.activateSubmitButton()
    }
    
    @objc private func confirmPasswordTapped() {
        mainView.highlightButton(mainView.confirmPasswordField)
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
        
        if mainView.oldPasswordField.frame.contains(location)
            || mainView.newPasswordField.frame.contains(location)
            || mainView.confirmPasswordField.frame.contains(location) {
            return
        }
        
        view.endEditing(true)
        mainView.resetAllButtonHighlights()
        validateFields()
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
