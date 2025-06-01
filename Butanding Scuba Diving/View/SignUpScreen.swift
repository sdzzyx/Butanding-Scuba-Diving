//
//  SignUpScreen.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import UIKit
import SnapKit

class SignUpScreen: UIViewController, UITextFieldDelegate {
    
    let backButton = UIButton()
    let signUpLabel = UILabel()
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let submitButton = UIButton()
    
    override func viewDidLoad() {
        SignUpUI()
        setUpKeyboardDismissGesture()
        navigationItem.hidesBackButton = true
    }
    
    func SignUpUI() {
        
        view.backgroundColor = .white

        backButton.imageView?.contentMode = .scaleAspectFit
        
        //backButton.setImage(UIImage(systemName: "back-logo"), for: .normal)
        backButton.setImage(UIImage(named: "back-logo"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(70)
        }
        
        signUpLabel.text = "Sign Up"
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.textAlignment = .right
        view.addSubview(signUpLabel)
        
        signUpLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().inset(20)
        }
        
        // Create the full attributed text
        let fullText = "Sign Up"
        let attributedString = NSMutableAttributedString(string: fullText)

        // Define ranges
        let upRange = (fullText as NSString).range(of: "Up")
        let signRange = (fullText as NSString).range(of: "Sign")

        // Fonts
        let regularFont = UIFont.systemFont(ofSize: 40)
        let boldFont = UIFont.boldSystemFont(ofSize: 40)
        
        // Styling "Sign Up individual Color?"
        attributedString.addAttributes([
            .foregroundColor: UIColor.customBlue,
            .font: regularFont
        ], range: signRange)

        // Styling "Sign Up"
        attributedString.addAttributes([
            .foregroundColor: UIColor.orange,
            .font: boldFont
        ], range: upRange)

        signUpLabel.attributedText = attributedString
        
        // Styling TextField
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
        
        // MARK: First Name
        styleTextField(firstNameTextField, placeholder: "First Name")
        firstNameTextField.delegate = self
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }

        // MARK: Last Name
        styleTextField(lastNameTextField, placeholder: "Last Name")
        lastNameTextField.delegate = self
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(16)
            make.left.right.equalTo(firstNameTextField)
        }

        // MARK: Email
        styleTextField(emailTextField, placeholder: "Email")
        emailTextField.delegate = self
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(16)
            make.left.right.equalTo(lastNameTextField)
        }

        // MARK: Password
        styleTextField(passwordTextField, placeholder: "Password")
        passwordTextField.delegate = self
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
        }

        // MARK: Confirm Password
        styleTextField(confirmPasswordTextField, placeholder: "Confirm Password")
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.left.right.equalTo(passwordTextField)
        }

        // MARK: Submit Button
        styleButton(submitButton, title: "Submit", backgroundColor: .orange)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(200)
            make.left.right.equalTo(confirmPasswordTextField)
            make.height.equalTo(50)
        }
        
        let privacyPolicyLabel = UILabel()
        privacyPolicyLabel.numberOfLines = 1
        privacyPolicyLabel.adjustsFontSizeToFitWidth = false
        privacyPolicyLabel.textAlignment = .center
        privacyPolicyLabel.lineBreakMode = .byTruncatingTail
        view.addSubview(privacyPolicyLabel)

        let text = "By joining, you agree with our Privacy and Policy"
        let attributedText = NSMutableAttributedString(string: text)

        // Font size 10
        let regularSmallFont = UIFont.systemFont(ofSize: 13)
        let boldSmallFont = UIFont.boldSystemFont(ofSize: 13)

        // Make full text gray
        attributedText.addAttributes([
            .foregroundColor: UIColor.gray,
            .font: regularSmallFont
        ], range: NSRange(location: 0, length: text.count))

        // Make "Privacy Policy" customBlue + bold
        let policyRange = (text as NSString).range(of: "Privacy and Policy")
        attributedText.addAttributes([
            .foregroundColor: UIColor.customBlue,
            .font: boldSmallFont
        ], range: policyRange)

        privacyPolicyLabel.attributedText = attributedText

        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(10)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func backButtonAction() {
        print("Back Button Tapped")
        navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signUpButtonAction() {
        
    }
    
}

