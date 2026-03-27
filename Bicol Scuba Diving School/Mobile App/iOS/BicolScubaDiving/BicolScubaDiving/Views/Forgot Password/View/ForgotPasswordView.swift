//
//  ForgotPasswordView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 11/20/25.
//

import UIKit
import SnapKit

final class ForgotPasswordView: UIView {

    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = .roboto(.bold, size: 24)
        label.textColor = .primaryBlueColor
        label.textAlignment = .center
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Reset Link", for: .normal)
        button.titleLabel?.font = .roboto(.medium, size: 17)
        button.backgroundColor = .primaryOrange
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .primaryOrange
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(resetButton)
        addSubview(messageLabel)
        addSubview(activityIndicator)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        resetButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Public Methods
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            resetButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            resetButton.isEnabled = true
        }
    }

    func showMessage(_ text: String, color: UIColor) {
        messageLabel.text = text
        messageLabel.textColor = color
    }
}
