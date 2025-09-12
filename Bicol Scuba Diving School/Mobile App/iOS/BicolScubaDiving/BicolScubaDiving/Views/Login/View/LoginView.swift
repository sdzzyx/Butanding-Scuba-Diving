//
//  LoginView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit

class LoginView: UIView {
    
    // Closure Function
    var onLoginTapped: ((String, String) -> Void)?
    var onForgotPasswordTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    var onGoogleSignInTapped: (() -> Void)?
    var onAppleSignInTapped: (() -> Void)?
    var onFacebookSignInTapped: (() -> Void)?
    
    // UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let passwordStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private let socialMediaStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    
    private let loginButton = CustomButton()
    private let footerButton = UIButton()
    private let appleButton = UIButton()
    private let facebookButton = UIButton()
    private let googleButton = UIButton()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.roboto(.regular, size: 14)
        button.backgroundColor = .clear
        return button 
    }()
    
    private let forgotPasswordView = UIView()

    // MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupLayout()
        setupObserver()
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Set the forgot password view content
        forgotPasswordView.addSubview(forgotPasswordButton)
        
        // Set the passwordStackView content
        [loginButton, forgotPasswordView].forEach { passwordStackView.addArrangedSubview($0)}
        
        // Set the primary StackView content
        [emailTextField, passwordTextField, passwordStackView].forEach { stackView.addArrangedSubview($0) }
        
        // Set the content for social media inside the Social Media StackView
        [appleButton, facebookButton, googleButton].forEach { socialMediaStackView.addArrangedSubview($0) }

        addSubview(logoImageView)
        addSubview(stackView)
        addSubview(socialMediaStackView)
        addSubview(footerButton)
    }
    
    private func setupObserver() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        forgotPasswordView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        footerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-35)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
    }

    @objc private func textFieldDidChange() {
        let isEmailFilled = !(emailTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        let isPasswordFilled = !(passwordTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        loginButton.isEnabled = isEmailFilled && isPasswordFilled
    }

    // MARK: - Public Interface
    func configure(with data: LoginViewData) {
        logoImageView.image = data.logoImage
        emailTextField.setPlaceholder(data.emailPlaceholder)
        passwordTextField.setPlaceholder(data.passwordPlaceholder)
        loginButton.setTitle(data.loginButtonTitle, for: .normal)
        forgotPasswordButton.setTitle(data.forgotButtonTitle, for: .normal)
        
        // Configure the Social Media Buttons
        configureSocialButton(appleButton, with: data.appleButtonImage)
        configureSocialButton(googleButton, with: data.googleButtonImage)
        configureSocialButton(facebookButton, with: data.facebookButtonImage)

        // Footer Button Attribute Title
        let attributedTitle = NSAttributedString.makeHighlighting(
            fullText: data.footerText, 
            highlights: data.footerTextHighlights,
            baseFont: UIFont.roboto(.regular, size: 16),
            baseTextColor: .primaryBlueColor,
            highlightFont: UIFont.roboto(.bold, size: 16),
            highlightColor: .primaryOrange
        )
        
        footerButton.setAttributedTitle(attributedTitle, for: .normal)
        
        footerButton.enableTapAnimation()
        
        [appleButton, facebookButton, googleButton].forEach {
            $0.enableTapAnimation()
        }
        
        socialMediaStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(footerButton.snp.top).offset(-40)
        }
    }
    
    private func configureSocialButton(_ button: UIButton, with image: UIImage?) {
        // Handle the tap effect of the buttons
        var config = UIButton.Configuration.plain()
        config.image = image
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.applyTapEffectWithConfiguration()
    }
    
    func bindLoginAction() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    func bindFogotPasswordAction() {
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    }
    
    func bindSignUpAction() {
        footerButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    func bindGoogleSignInAction() {
        googleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
    }
    
    func bindAppleSignInAction() {
        appleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
    }
    
    func bindFacebookSignInAction() {
        facebookButton.addTarget(self, action: #selector(handleFacebookSignIn), for: .touchUpInside)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    
    // MARK: - Handle Tap Actions
    @objc private func handleLogin() {
        guard let username = emailTextField.text, 
                let password = passwordTextField.text 
        else { 
            return 
        }
        
        onLoginTapped?(username, password)
    }
    
    @objc private func handleForgotPassword() {
        onForgotPasswordTapped?()
    }
    
    @objc private func handleSignUp() {
        onSignUpTapped?()
    }
    
    @objc private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
    
    @objc private func handleAppleSignIn() {
        onAppleSignInTapped?()
    }
    
    @objc private func handleFacebookSignIn() {
        onFacebookSignInTapped?()
    }

}
