//
//  ChangePasswordView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit
import SnapKit

class ChangePasswordView: UIView {
    
    // MARK: - UI Components
    
    let backButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.enableTapAnimation()
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.roboto(.bold, size: 18)
        label.textColor = .primaryBlueColor
        label.textAlignment = .right
        return label
    }()
    
    let oldPasswordButton = ChangePasswordView.createFieldButton()
    let newPasswordButton = ChangePasswordView.createFieldButton()
    let confirmPasswordButton = ChangePasswordView.createFieldButton()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.roboto(.medium, size: 13)
        label.textColor = .primaryOrange
        label.textAlignment = .left
        return label
    }()
    
    let submitButton: CustomButton = {
        let button = CustomButton()
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    static func createFieldButton() -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(white: 0.95, alpha: 1)
        config.baseForegroundColor = .primaryGrayTextColor
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    func highlightButton(_ button: UIButton) {
        [oldPasswordButton, newPasswordButton, confirmPasswordButton].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.primaryOrange.cgColor
    }
    
    func activateSubmitButton() {
        submitButton.isEnabled = true
        submitButton.backgroundColor = .primaryOrange
    }
    
    func resetAllButtonHighlights() {
        [oldPasswordButton, newPasswordButton, confirmPasswordButton].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func configure(with data: ChangePasswordViewData) {
        titleLabel.text = data.title
        oldPasswordButton.setTitle(data.oldPasswordPlaceholder, for: .normal)
        newPasswordButton.setTitle(data.newPasswordPlaceholder, for: .normal)
        confirmPasswordButton.setTitle(data.confirmNewPasswordPlaceholder, for: .normal)
        descriptionLabel.text = data.descriptionText
        submitButton.setTitle(data.submitTitle, for: .normal)
        
        if let originalImage = data.backLogoImage {
            let desiredSize = CGSize(width: 65, height: 65)
            let resizedImage = originalImage.resized(to: desiredSize)
            backButton.setImage(resizedImage, for: .normal)
        } else {
            backButton.setImage(nil, for: .normal)
        }
        
        let buttonFont = UIFont.roboto(.medium, size: 13)
        
        oldPasswordButton.setAttributedTitle(NSAttributedString(
            string: data.oldPasswordPlaceholder,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        newPasswordButton.setAttributedTitle(NSAttributedString(
            string: data.newPasswordPlaceholder,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        confirmPasswordButton.setAttributedTitle(NSAttributedString(
            string: data.confirmNewPasswordPlaceholder,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        if let originalImage = data.backLogoImage {
            let desiredSize = CGSize(width: 65, height: 65)
            let resizedImage = originalImage.resized(to: desiredSize)
            backButton.setImage(resizedImage, for: .normal)
        } else {
            backButton.setImage(nil, for: .normal)
        }
        
        // Title highlighting
        let highlights = [
            NSAttributedString.HighlightStyle(substring: "Change", font: UIFont.roboto(.bold, size: 28), color: .primaryBlueColor),
            NSAttributedString.HighlightStyle(substring: "Password", font: UIFont.roboto(.bold, size: 28), color: .primaryOrange)
        ]
        
        let attrString = NSAttributedString.highlightedString(
            fullText: data.title,
            baseFont: UIFont.roboto(.regular, size: 25),
            baseColor: .black,
            highlights: highlights
        )
        
        titleLabel.attributedText = attrString
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [backButton, titleLabel, oldPasswordButton, newPasswordButton, confirmPasswordButton, descriptionLabel, submitButton].forEach(addSubview)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(30)
        }
        
        oldPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        newPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(oldPasswordButton.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(oldPasswordButton)
        }
        
        confirmPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(newPasswordButton.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(oldPasswordButton)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(oldPasswordButton)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(270)
            make.leading.trailing.equalTo(confirmPasswordButton)
            make.height.equalTo(55)
        }
    }
}
