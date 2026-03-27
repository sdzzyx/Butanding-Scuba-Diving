//
//  ChangePasswordViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/5/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    func submitChangePassword(model: ChangePasswordModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard validate(model: model) else {
            completion(.failure(NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Validation failed."])))
            return
        }
        
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: model.oldPassword)
        
        // Step 1: Reauthenticate
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Step 2: Update password in FirebaseAuth
            user.updatePassword(to: model.newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Step 3: (Optional) Update Firestore if you want to log password change time
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).updateData([
                    "passwordChangedAt": FieldValue.serverTimestamp()
                ]) { firestoreError in
                    if let firestoreError = firestoreError {
                        print("Firestore update error: \(firestoreError.localizedDescription)")
                    }
                }
                
                completion(.success(()))
            }
        }
    }
    
    func backTapped() {
        print("Back tapped")
    }
}
