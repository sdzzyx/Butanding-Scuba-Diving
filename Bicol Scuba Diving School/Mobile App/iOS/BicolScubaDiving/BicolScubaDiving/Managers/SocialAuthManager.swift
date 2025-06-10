//
//  AuthManager.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import CryptoKit

class SocialAuthManager {
    
    static let shared = SocialAuthManager()
    private init() {}
 
    var authenticationCompletion: (() -> Void)?
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        
    }
    
    func signInWithApple() {
        
    }
    
    
}
