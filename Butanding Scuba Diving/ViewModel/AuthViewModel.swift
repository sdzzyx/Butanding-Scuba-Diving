//
//  AuthViewModel.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class GoogleAuthViewModel {
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "NoClientID", code: -1, userInfo: nil)))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        //Google Sign-In
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                completion(.failure(NSError(domain: "NoResult", code: -1, userInfo: nil)))
                return
            }
            
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "TokenError", code: -1, userInfo: nil)))
                return
            }
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = authResult?.user {
                    completion(.success(user))
                }
            }
        }
    }
}
