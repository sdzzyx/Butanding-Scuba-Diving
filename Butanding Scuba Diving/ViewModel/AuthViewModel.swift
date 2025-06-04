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
import AuthenticationServices
import CryptoKit


typealias AuthResult = Result<User, Error>

class AuthViewModel: NSObject {
    
    // MARK: - Outputs (to notify the View)
    // This completion handler will be called when any authentication process completes
    var authenticationCompletion: ((AuthResult) -> Void)?
    
    // MARK: - Apple Sign-In Specific Properties
    private var currentNonce: String? // Secure nonce for Apple Sign-In
    
    // MARK: - Google Sign-In
    
    /// Initiates the Google Sign-In flow.
    /// - Parameter presentingVC: The UIViewController that will present the Google Sign-In UI.
    func signInWithGoogle(presentingVC: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            // Use the authenticationCompletion to report errors back to the view
            self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase client ID not found. Ensure Firebase is configured."])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            guard let self = self else { return } // Safely unwrap self for closure capture
            
            if let error = error {
                print("Google Sign-In GIDSignIn error: \(error.localizedDescription)")
                self.authenticationCompletion?(.failure(error))
                return
            }
            
            guard let result = result else {
                print("Google Sign-In result is nil.")
                self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In result is nil."])))
                return
            }
            
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                print("Google ID token is nil.")
                self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google ID token is nil."])))
                return
            }
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )
            
            // Authenticate with Firebase using Google credentials
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Google Auth error: \(error.localizedDescription)")
                    self.authenticationCompletion?(.failure(error))
                } else if let firebaseUser = authResult?.user {
                    print("Firebase Google Auth successful for user: \(firebaseUser.email ?? "N/A")")
                    self.authenticationCompletion?(.success(firebaseUser))
                }
            }
        }
    }
    
    
    // MARK: - Apple Sign-In
    
    /// Initiates the Sign in with Apple flow.
    /// The actual presentation context for the Apple Sign-In UI is provided by
    /// the `ASAuthorizationControllerPresentationContextProviding` protocol, which this ViewModel conforms to.
    func signInWithApple() {
        // Guard against running on iOS versions older than 13
        guard #available(iOS 13.0, *) else {
            self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign in with Apple requires iOS 13 or later."])))
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce // Store the generated nonce for later verification
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] // Request user's full name and email (optional)
        request.nonce = sha256(nonce) // Hash the nonce before sending it in the request
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self // Set this ViewModel as the delegate for authorization callbacks
        authorizationController.presentationContextProvider = self // Set this ViewModel for providing the UI presentation context
        authorizationController.performRequests() // Start the Apple Sign-In process
    }
    
    // MARK: - Nonce Generation (Security for Apple Sign-In)
    
    // Generates a cryptographically secure random string to be used as a nonce.
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                // Generate cryptographically secure random bytes
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            for random in randoms {
                if remainingLength == 0 {
                    break
                }
                // Only use characters that are within the defined charset range
                if Int(random) < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    // Hashes the input string using the SHA256 algorithm.
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        // Convert the hashed data to a hexadecimal string representation
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate (AuthViewModel acts as delegate for Apple Sign-In)
@available(iOS 13.0, *)
extension AuthViewModel: ASAuthorizationControllerDelegate {
    
    // This method is called when the Apple Sign-In authorization flow completes successfully.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: An Apple Sign-In callback was received, but no nonce was stored for verification. This indicates a potential security issue.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple ID token is missing from authorization credential."])))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.authenticationCompletion?(.failure(NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert Apple ID token data to a string."])))
                return
            }
            
            // Create a Firebase credential specifically for Apple Sign-In
            let firebaseCredential = OAuthProvider.credential(providerID: AuthProviderID.apple,
                idToken: idTokenString,
                rawNonce: nonce)
            
            // Sign in to Firebase with the Apple credentials
            Auth.auth().signIn(with: firebaseCredential) { [weak self] authResult, error in
                if let error = error {
                    print("Firebase authentication with Apple failed: \(error.localizedDescription)")
                    self?.authenticationCompletion?(.failure(error))
                } else if let user = authResult?.user {
                    print("Firebase authentication with Apple successful for user: \(user.email ?? "N/A")")
                    // On the first sign-in, you might get the user's full name and email from appleIDCredential:
                    // appleIDCredential.fullName
                    // appleIDCredential.email
                    // You might want to save this information if your app requires it.
                    self?.authenticationCompletion?(.success(user))
                }
                self?.currentNonce = nil // Clear the nonce after it has been used
            }
        }
    }
    
    // This method is called when the Apple Sign-In authorization flow fails or is cancelled by the user.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In process failed: \(error.localizedDescription)")
        // Pass the error directly back to the View for handling (e.g., showing an alert)
        self.authenticationCompletion?(.failure(error))
        self.currentNonce = nil // Clear the nonce even on error
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding (AuthViewModel provides UI context)
@available(iOS 13.0, *)
extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    // This method provides the anchor UIWindow for the Apple Sign-In sheet to be presented on.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // This attempts to find the key window of your application.
        // It's generally the correct window to present the Apple Sign-In UI from.
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            fatalError("No key window found for Apple Sign-In presentation. Ensure your app has a UIWindowScene and a key window visible.")
        }
        return window
    }
}
