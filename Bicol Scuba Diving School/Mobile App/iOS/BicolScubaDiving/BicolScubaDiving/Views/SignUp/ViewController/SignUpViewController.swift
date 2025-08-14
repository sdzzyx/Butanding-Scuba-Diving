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
}
