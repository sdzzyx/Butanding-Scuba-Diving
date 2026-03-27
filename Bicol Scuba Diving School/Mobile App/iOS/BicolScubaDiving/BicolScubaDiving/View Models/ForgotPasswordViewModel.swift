//
//  ForgotPasswordViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 11/20/25.
//

import Foundation
import FirebaseAuth

final class ForgotPasswordViewModel {

    // MARK: - Callbacks
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    // MARK: - Public Method
    func sendPasswordReset(email: String) {
        guard !email.isEmpty else {
            onError?("Please enter your email")
            return
        }

        onLoading?(true)
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            self.onLoading?(false)

            if let error = error {
                self.onError?(error.localizedDescription)
            } else {
                self.onSuccess?("A password reset link has been sent to \(email)")
            }
        }
    }
}
