//
//  ChangePasswordViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit

// MARK: - ViewData Struct
struct ChangePasswordViewData {
    let backLogoImage: UIImage?
    let title: String
    let oldPasswordPlaceholder: String
    let newPasswordPlaceholder: String
    let confirmNewPasswordPlaceholder: String
    let descriptionText: String
    let submitTitle: String
}



class ChangePasswordViewModel {
    
    // View data for configuring UI text
    var viewData: ChangePasswordViewData {
        return ChangePasswordViewData(
            backLogoImage: UIImage(named: "back-logo"), 
            title: AppConstant.ChangePassword.title,
            oldPasswordPlaceholder: AppConstant.ChangePassword.oldPasswordPlaceholder,
            newPasswordPlaceholder: AppConstant.ChangePassword.newPasswordPlaceholder,
            confirmNewPasswordPlaceholder: AppConstant.ChangePassword.confirmNewPasswordPlaceholder,
            descriptionText: AppConstant.ChangePassword.descriptionLabel,
            submitTitle: AppConstant.ChangePassword.submitTitle
        )
    }
    
    func validate(model: ChangePasswordModel) -> Bool {
        guard !model.oldPassword.isEmpty,
              !model.newPassword.isEmpty,
              !model.confirmPassword.isEmpty else { return false }
        
        guard model.newPassword == model.confirmPassword else { return false }
        
        return true
    }
    
    // Action when submit tapped
    func submitChangePassword(model: ChangePasswordModel) {
        if validate(model: model) {
            print("Password change validated and ready to submit!")
            // Logic
        } else {
            print("Validation failed.")
        }
    }
    
    func backTapped() {
        print("Back tapped")
    }
}
