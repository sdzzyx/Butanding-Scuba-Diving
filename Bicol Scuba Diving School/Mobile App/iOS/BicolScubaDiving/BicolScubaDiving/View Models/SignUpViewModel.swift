//
//  SignUpViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/30/25.
//

import UIKit

struct SignUpViewData {
    let backLogoImage: UIImage?
    let signUpTitle: String
    let firstNamePlaceholder: String
    let lastNamePlaceholder: String
    let emailPlaceholder: String
    let passwordPlaceholder: String
    let confirmPasswordPlaceholder: String
    let submitButtonTitle: String
    let footerText: String
    let footerTextHighlights: [String]
}

class SignUpViewModel {
    
    var viewData: SignUpViewData {
        return SignUpViewData(
            backLogoImage: UIImage(named: "back-logo"),
            signUpTitle: AppConstant.SignUp.signUpTitle,
            firstNamePlaceholder: AppConstant.SignUp.firstNamePlaceholder,
            lastNamePlaceholder: AppConstant.SignUp.lastNamePlaceholder,
            emailPlaceholder: AppConstant.SignUp.emailPlaceholder,
            passwordPlaceholder: AppConstant.SignUp.passwordPlaceholder,
            confirmPasswordPlaceholder: AppConstant.SignUp.confirmPasswordPlaceholder,
            submitButtonTitle: AppConstant.SignUp.submitTitle,
            footerText: AppConstant.SignUp.footerText,
            footerTextHighlights: ["Terms", "Privacy Policy"]
        )
    }
    
    func submit(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) {
        
    }
    
    func backTapped() {
        print("Back tapped")
        
    }
}
