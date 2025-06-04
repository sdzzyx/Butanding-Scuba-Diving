//
//  LoginScreen.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import UIKit
import SnapKit
import GoogleSignIn
import AuthenticationServices

class LoginScreen: UIViewController, UITextFieldDelegate {
    
    private let authViewModel = AuthViewModel()
    
    let logoView = UIImageView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let forgotPassword = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginUI()
        setUpKeyboardDismissGesture()
        setUpViewModelBinding()
    }
    
    func LoginUI() {
        
        view.backgroundColor = .white
        
        logoView.image = UIImage(named: "logo-main")
        logoView.contentMode = .scaleAspectFit
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-250)
            make.width.height.equalTo(250)
        }
        
        
        // MARK: TextField Styling
        func styleTextField(_ textField: UITextField, placeholder: String) {
            let placeholderColor = UIColor.gray
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            textField.placeholder = placeholder
            textField.borderStyle = .none
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 0.90
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.textColor = .black
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) // less padding
            textField.leftViewMode = .always
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true // smaller height
            view.addSubview(textField)
        }
        
        // MARK: Button Styling
        func styleButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
            button.setTitle(title, for: .normal)
            button.backgroundColor = backgroundColor
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        
        // MARK: Email
        styleTextField(emailTextField, placeholder: "Email")
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }
        
        // MARK: Password
        styleTextField(passwordTextField, placeholder: "Password")
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
        }
        
        // MARK: Login Button
        styleButton(loginButton, title: "Login", backgroundColor: .orange)
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        
        forgotPassword.text = "Forgot Password?"
        //tappable
        //                forgotPasswordLabel.isUserInteractionEnabled = true
        //                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        //                forgotPasswordLabel.addGestureRecognizer(tapGesture)
        forgotPassword.font = UIFont.systemFont(ofSize: 14)
        forgotPassword.textColor = .black
        forgotPassword.textAlignment = .right
        view.addSubview(forgotPassword)
        
        forgotPassword.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.bottom).offset(30) // Adjusted constraint to be relative to loginButton
            make.right.equalTo(loginButton.snp.right)
        }
        
        
        // MARK: OR Separator
        let separatorStack = UIStackView()
        separatorStack.axis = .horizontal
        separatorStack.alignment = .center
        separatorStack.distribution = .fill
        separatorStack.spacing = 8
        
        let leftLine = UIView()
        leftLine.backgroundColor = .lightGray
        leftLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        let orLabel = UILabel()
        orLabel.text = "or"
        orLabel.font = UIFont.systemFont(ofSize: 14)
        orLabel.textColor = .black
        orLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let rightLine = UIView()
        rightLine.backgroundColor = .lightGray
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        // Add to stack
        separatorStack.addArrangedSubview(leftLine)
        separatorStack.addArrangedSubview(orLabel)
        separatorStack.addArrangedSubview(rightLine)
        
        // Add to view
        view.addSubview(separatorStack)
        
        // Layout
        separatorStack.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }
        
        leftLine.snp.makeConstraints { make in
            make.width.equalTo(rightLine)
        }
        
        // MARK: Google/Apple login icon buttons
        let icons = ["google-logo", "apple-logo"]
        let actions: [Selector] = [#selector(googleTapped), #selector(appleTapped)]
        
        let socialStack = UIStackView()
        socialStack.axis = .horizontal
        socialStack.spacing = 24
        socialStack.alignment = .center
        socialStack.distribution = .fillEqually
        view.addSubview(socialStack)
        
        for (index, iconName) in icons.enumerated() {
            let button = UIButton()
            button.setImage(UIImage(named: iconName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.backgroundColor = .white
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            button.addTarget(self, action: actions[index], for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
            socialStack.addArrangedSubview(button)
        }
        
        socialStack.snp.makeConstraints { make in
            make.top.equalTo(separatorStack.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let signUpLabel = UILabel()
        signUpLabel.isUserInteractionEnabled = true
        view.addSubview(signUpLabel)
        
        // Create the full attributed text
        let fullText = "Don't have an account yet? Sign Up"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Define ranges
        let signUpRange = (fullText as NSString).range(of: "Sign Up")
        let questionRange = (fullText as NSString).range(of: "Don't have an account yet?")
        
        // Fonts
        let regularFont = UIFont.systemFont(ofSize: 14)
        let boldFont = UIFont.boldSystemFont(ofSize: 14)
        
        // Styling "Don't have an account yet?"
        attributedString.addAttributes([
            .foregroundColor: UIColor.customBlue,
            .font: regularFont
        ], range: questionRange)
        
        // Styling "Sign Up"
        attributedString.addAttributes([
            .foregroundColor: UIColor.orange,
            .font: boldFont
        ], range: signUpRange)
        
        signUpLabel.attributedText = attributedString
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTap))
        signUpLabel.addGestureRecognizer(tapGesture)
        
        // Constraints
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(socialStack.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.textColor = .customBlue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textColor = .black
    }
    
    // MARK: Dismiss Keyboard & end editing to the textfields
    func setUpKeyboardDismissGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: When user taps return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setUpViewModelBinding() {
        authViewModel.authenticationCompletion = { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("Authentication successful for user: \(user.email ?? "N/A")")
                    self.showSuccessAlert(message: "Successfully signed in as \(user.displayName ?? user.email ?? "user")!")
                    self.navigateToMainViewController()
                case .failure(let error):
                    print("Authentication failed with error: \(error.localizedDescription)")
                    // Handle specific error types for user-friendly messages
                    if let asError = error as? ASAuthorizationError, asError.code == .canceled {
                        self.showErrorAlert(message: "Sign-In with Apple was cancelled.")
                    } else if let googleError = error as? GIDSignInError, googleError.code == GIDSignInError.Code.canceled {
                        self.showErrorAlert(message: "Sign-In with Google was cancelled.")
                    } else {
                        self.showErrorAlert(message: "Sign-In failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func appleTapped() {
        authViewModel.signInWithApple()
    }
    
    @objc func googleTapped() {
        authViewModel.signInWithGoogle(presentingVC: self)
    }
    
    
    @objc func signUpTap() {
        print("Sign Up Tapped")
        let signUpVC = SignUpScreen()
        navigationController?.pushViewController(signUpVC, animated: true)
        //self.dismiss(animated: true, completion: nil) 
    }
    
    private func navigateToMainViewController() {
        let mainViewController = MainViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            UIView.transition(with: sceneDelegate.window!,
                              duration: 0.5,
                              options: .transitionCrossDissolve, // for smooth transition
                              animations: {
                sceneDelegate.window?.rootViewController = mainViewController
            },
                              completion: nil)
        }
    }
    
    // Helper function to show an alert
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Custom Blue color
extension UIColor {
    static let customBlue = UIColor(red: 43/255, green: 92/255, blue: 167/255, alpha: 1)
}
