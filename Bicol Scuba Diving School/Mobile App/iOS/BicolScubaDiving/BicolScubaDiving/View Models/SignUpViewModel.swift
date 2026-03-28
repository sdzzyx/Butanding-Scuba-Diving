//
//  SignUpViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/30/25.
//

import UIKit
import FirebaseAuth

struct SignUpViewData {
    let backLogoImage: UIImage?
    let signUpTitle: String
    let firstNamePlaceholder: String
    let lastNamePlaceholder: String
    let emailPlaceholder: String
    let phoneNumberPlaceholder: String
    let passwordPlaceholder: String
    let confirmPasswordPlaceholder: String
    let submitButtonTitle: String
    let footerText: String
    let footerTextHighlights: [String]
}

class SignUpViewModel {
    
    var onSignUpSuccess: ((String) -> Void)?
    var onSignUpFailure: ((Error) -> Void)?
    var onVerificationEmailSent: (() -> Void)?
    
    var viewData: SignUpViewData {
        return SignUpViewData(
            backLogoImage: UIImage(named: "back-logo"),
            signUpTitle: AppConstant.SignUp.signUpTitle,
            firstNamePlaceholder: AppConstant.SignUp.firstNamePlaceholder,
            lastNamePlaceholder: AppConstant.SignUp.lastNamePlaceholder,
            emailPlaceholder: AppConstant.SignUp.emailPlaceholder,
            phoneNumberPlaceholder: AppConstant.SignUp.phoneNumberPlaceholder,
            passwordPlaceholder: AppConstant.SignUp.passwordPlaceholder,
            confirmPasswordPlaceholder: AppConstant.SignUp.confirmPasswordPlaceholder,
            submitButtonTitle: AppConstant.SignUp.submitTitle,
            footerText: AppConstant.SignUp.footerText,
            footerTextHighlights: ["Terms", "Privacy Policy"]
        )
    }
    
    func submit(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            let error = NSError(domain: "SignUp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match"])
            onSignUpFailure?(error)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.onSignUpFailure?(error)
                return
            }
            
            if let user = result?.user {
                // Update display name with first + last name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = "\(firstName) \(lastName)"
                changeRequest.commitChanges { _ in
                    
                    // Create Firestore user doc here
                    FirestoreService.shared.createUserIfNeeded(user: user) { _ in
                        //                                FirestoreService.shared.fetchUserRole(uid: user.uid) { role in
                        //                                    DispatchQueue.main.async {
                        //                                        self?.onSignUpSuccess?(role) // pass role back
                        //                                    }
                        //                                }
                    }
                    
                    // Send email verification
                    user.sendEmailVerification { sendError in
                        if let sendError = sendError {
                            self?.onSignUpFailure?(sendError)
                        } else {
                            print("Verification email sent to \(email)")
                            self?.onVerificationEmailSent?()
                        }
                    }
                }
            }
        }
    }
    
    func backTapped() {
        print("Back tapped")
        
    }
}
