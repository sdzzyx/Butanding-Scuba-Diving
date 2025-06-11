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
import GoogleSignIn

typealias AuthResult = Result<User, Error>

final class SocialAuthManager: NSObject {

    static let shared = SocialAuthManager()
    private override init() {}
 
    private var currentNonce: String?
    var authCompletion: ((AuthResult) -> Void)?
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (AuthResult) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase client ID not found."])))
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        self.authCompletion = completion
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let result = result,
                  let idToken = result.user.idToken?.tokenString else {
                return completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Google Sign-In result."])))
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
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
    
    func signInWithApple(completion: @escaping (AuthResult) -> Void) {
        guard #available(iOS 13.0, *) else {
            completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "iOS 13 or later required."])))
            return
        }
        
        let nonce = CryptoUtils.randomNonceString() // randomNonceString()
        currentNonce = nonce
        self.authCompletion = completion
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtils.sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SocialAuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let tokenData = credential.identityToken,
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple Sign-In data."])))
            return
        }

        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: nonce
        )

        Auth.auth().signIn(with: firebaseCredential) { [weak self] result, error in
            if let error = error {
                self?.authCompletion?(.failure(error))
            } else if let user = result?.user {
                self?.authCompletion?(.success(user))
            }
            self?.currentNonce = nil
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authCompletion?(.failure(error))
        currentNonce = nil
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
