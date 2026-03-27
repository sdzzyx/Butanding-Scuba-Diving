//
//  PersonalInformationViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit
import FirebaseAuth

class PersonalInformationViewController: UIViewController {
    
    private let mainView = PersonalInformationView()
    private let viewModel = PersonalInformationViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        bindViewModel()
        setupActions()
        updateView()
    }
    
    private func bindViewModel() {
        viewModel.infoUpdated = { [weak self] in
            self?.updateView()
        }
    }
    
    private func updateView() {
        let data = viewModel.viewData
        mainView.configure(with: data)
    }
    
    private func setupActions() {
        // TextField Editing Handlers
        mainView.firstNameField.addTarget(self, action: #selector(firstNameFieldFocused), for: .editingDidBegin)
        mainView.lastNameField.addTarget(self, action: #selector(lastNameFieldFocused), for: .editingDidBegin)
        mainView.emailField.addTarget(self, action: #selector(emailFieldFocused), for: .editingDidBegin)
        mainView.phoneField.addTarget(self, action: #selector(phoneFieldFocused), for: .editingDidBegin)
        
        // Update and Back button
        mainView.updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Dismiss keyboard and reset highlights
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Focus Actions (Highlighting)
    
    @objc private func firstNameFieldFocused() {
        mainView.highlightField(mainView.firstNameField)
        mainView.activateUpdateButton()
    }
    
    @objc private func lastNameFieldFocused() {
        mainView.highlightField(mainView.lastNameField)
        mainView.activateUpdateButton()
    }
    
    @objc private func emailFieldFocused() {
        mainView.highlightField(mainView.emailField)
        mainView.activateUpdateButton()
    }
    
    @objc private func phoneFieldFocused() {
        mainView.highlightField(mainView.phoneField)
        mainView.activateUpdateButton()
    }
    
    @objc private func updateButtonTapped() {
        
        let firstName = mainView.firstNameField.text ?? ""
        let lastName = mainView.lastNameField.text ?? ""
        let email = mainView.emailField.text ?? ""
        let phone = mainView.phoneField.text ?? ""
        
        // Save changes from fields to model
//        viewModel.updateFirstName(mainView.firstNameField.text ?? "")
//        viewModel.updateLastName(mainView.lastNameField.text ?? "")
//        viewModel.personalInfomation.email = mainView.emailField.text ?? ""
//        viewModel.updatePhone(mainView.phoneField.text ?? "")
        
        viewModel.updateFirstName(firstName)
            viewModel.updateLastName(lastName)
            viewModel.updatePhone(phone)
        
        viewModel.saveChanges()
        
        // Also update FirebaseAuth email if it changed
        if let user = Auth.auth().currentUser, user.email != email {
            user.sendEmailVerification(beforeUpdatingEmail: email) { [weak self] error in
                if let error = error {
                    print("Failed to update FirebaseAuth email:", error.localizedDescription)
                    self?.showAlert(
                        title: "Error",
                        message: "Could not update email: \(error.localizedDescription)"
                    )
                    return
                }
                
                print("Verification email sent to \(email)")
                self?.showAlert(
                    title: "Verify Your Email",
                    message: "A verification link has been sent to \(email). Please verify before using it to log in."
                )
            }
        } else {
            showAlert(title: "Updated", message: "Your information has been updated.")
        }
    }
    
    private func showAlert(title: String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        mainView.resetAllButtonHighlights()
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
