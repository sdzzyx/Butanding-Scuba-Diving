//
//  SignUpView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/30/25.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    // MARK: - Callbacks
    var onSubmitTapped: ((String, String, String, String, String) -> Void)?
    var onBackTapped: (() -> Void)?
    var onTextFieldDidBeginEditing: ((UITextField) -> Void)?
    var onTextFieldDidEndEditing: ((UITextField) -> Void)?
    var onTextFieldShouldReturn: ((UITextField) -> Bool)?
    
    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.enableTapAnimation()
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .right
        return label
    }()
    
    let firstNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        return textField
    }()
    
    let lastNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let confirmPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let submitButton: CustomButton = {
        let button = CustomButton()
        button.isEnabled = false
        return button
    }()
    
    private let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
        setupObservers()
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        [backButton, signUpLabel,
         firstNameTextField, lastNameTextField,
         emailTextField, passwordTextField, confirmPasswordTextField,
         submitButton, privacyPolicyLabel].forEach(addSubview)
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    private func setupObservers() {
        [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
            $0.delegate = self // Set delegate to self to handle text field appearance
        }
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Public Interface
    func configure(with data: SignUpViewData) {
        backButton.setImage(data.backLogoImage, for: .normal)
        firstNameTextField.setPlaceholder(data.firstNamePlaceholder)
        lastNameTextField.setPlaceholder(data.lastNamePlaceholder)
        emailTextField.setPlaceholder(data.emailPlaceholder)
        passwordTextField.setPlaceholder(data.passwordPlaceholder)
        confirmPasswordTextField.setPlaceholder(data.confirmPasswordPlaceholder)
        submitButton.setTitle(data.submitButtonTitle, for: .normal)
        
        if let originalImage = data.backLogoImage {
            let desiredSize = CGSize(width: 65, height: 65)
            let resizedImage = originalImage.resized(to: desiredSize)
            backButton.setImage(resizedImage, for: .normal)
        }
        
        
        // Configure Sign Up label
        let fullSignUpText = data.signUpTitle
        let attributedSignUpString = NSMutableAttributedString(string: fullSignUpText)
        
        let signRange = (fullSignUpText as NSString).range(of: "Sign")
        if signRange.location != NSNotFound {
            attributedSignUpString.addAttributes([
                .foregroundColor: UIColor.primaryBlueColor,
                .font: UIFont.roboto(.bold, size: 30)
            ], range: signRange)
        }
        
        let upRange = (fullSignUpText as NSString).range(of: "Up")
        if upRange.location != NSNotFound {
            attributedSignUpString.addAttributes([
                .foregroundColor: UIColor.primaryOrange,
                .font: UIFont.roboto(.bold, size: 30)
            ], range: upRange)
        }
        signUpLabel.attributedText = attributedSignUpString
        
        // Configure Privacy Policy label
        let attributedPolicyText = NSAttributedString.makeHighlighting(
            fullText: data.footerText,
            highlights: data.footerTextHighlights,
            baseFont: UIFont.systemFont(ofSize: 13),
            baseTextColor: .gray,
            highlightFont: UIFont.boldSystemFont(ofSize: 13),
            highlightColor: .primaryBlueColor
        )
        privacyPolicyLabel.attributedText = attributedPolicyText
    }
    
    // MARK: - Actions
    @objc private func textFieldsDidChange() {
        let isFilled = ![firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
            .map { $0.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true }
            .contains(true)
        submitButton.isEnabled = isFilled
    }
    
    @objc private func handleBack() {
        onBackTapped?()
    }
    
    @objc private func handleSubmit() {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        
        onSubmitTapped?(firstName, lastName, email, password, confirmPassword)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(30)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(firstNameTextField)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(lastNameTextField)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(220)
            make.leading.trailing.equalTo(confirmPasswordTextField)
            make.height.equalTo(55)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onTextFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onTextFieldDidEndEditing?(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return onTextFieldShouldReturn?(textField) ?? true
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
