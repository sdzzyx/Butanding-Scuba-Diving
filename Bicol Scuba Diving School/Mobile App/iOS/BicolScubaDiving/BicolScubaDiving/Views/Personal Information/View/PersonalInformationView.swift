//
//  PersonalInformationView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit
import SnapKit

class PersonalInformationView: UIView {
    
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
    
    let firstNameField: CustomTextField = {
        let field = CustomTextField()
        field.setPlaceholder(AppConstant.PersonalInformation.firstNamePlaceholder)
        field.layer.borderColor = UIColor.clear.cgColor
        field.backgroundColor = .primaryGrayDisableBackground
        return field
    }()
    
    let lastNameField: CustomTextField = {
        let field = CustomTextField()
        field.setPlaceholder(AppConstant.PersonalInformation.lastNamePlaceholder)
        field.layer.borderColor = UIColor.clear.cgColor
        field.backgroundColor = .primaryGrayDisableBackground
        return field
    }()

    let emailField: CustomTextField = {
        let field = CustomTextField()
        field.setPlaceholder(AppConstant.PersonalInformation.emailPlaceholder)
        field.layer.borderColor = UIColor.clear.cgColor
        field.backgroundColor = .primaryGrayDisableBackground
        return field
    }()

    let phoneField: CustomTextField = {
        let field = CustomTextField()
        field.setPlaceholder(AppConstant.PersonalInformation.phoneNumberPlaceholder)
        field.layer.borderColor = UIColor.clear.cgColor
        field.backgroundColor = .primaryGrayDisableBackground
        return field
    }()
    
    let updateButton: CustomButton = {
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
    
    func highlightField(_ field: CustomTextField) {
        
        [firstNameField, lastNameField, emailField, phoneField].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor // Make sure it's clear here
            $0.backgroundColor = .primaryGrayDisableBackground
        }
        
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.primaryOrange.cgColor
        field.backgroundColor = .primaryGrayDisableBackground
    }
    
    func activateUpdateButton() {
        updateButton.isEnabled = true
        updateButton.backgroundColor = .primaryOrange
    }
    
    func resetAllButtonHighlights() {
        [firstNameField, lastNameField, emailField, phoneField].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.backgroundColor = .primaryGrayDisableBackground
        }
        
        updateButton.isEnabled = false
        updateButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func configure(with data: PersonalInformationViewData) {
        titleLabel.text = data.title
        firstNameField.text = data.firstNameTitle
        lastNameField.text = data.lastNameTitle
        emailField.text = data.emailTitle
        phoneField.text = data.phoneTitle
        updateButton.setTitle(data.updateButtonTitle, for: .normal)
        
        if let originalImage = data.backLogoImage {
            let desiredSize = CGSize(width: 65, height: 65)
            let resizedImage = originalImage.resized(to: desiredSize)
            backButton.setImage(resizedImage, for: .normal)
        } else {
            backButton.setImage(nil, for: .normal)
        }
        
        let personalHighlights = [
            NSAttributedString.HighlightStyle(substring: "Personal", font: UIFont.roboto(.bold, size: 25), color: .primaryBlueColor),
            NSAttributedString.HighlightStyle(substring: "Information", font: UIFont.roboto(.bold, size: 25), color: .primaryOrange)
        ]
        
        let personalInfoAttrString = NSAttributedString.highlightedString(
            fullText: data.title,
            baseFont: UIFont.roboto(.regular, size: 25),
            baseColor: .black,
            highlights: personalHighlights
        )
        
        titleLabel.attributedText = personalInfoAttrString
        
        let buttonFont = UIFont.roboto(.medium, size: 13)
        
        firstNameField.text = data.firstNameTitle
        firstNameField.font = buttonFont
        
        lastNameField.text = data.lastNameTitle
        lastNameField.font = buttonFont
        
        emailField.text = data.emailTitle
        emailField.font = buttonFont
        
        phoneField.text = data.phoneTitle
        phoneField.font = buttonFont

    }
    
    
    // MARK: - Setup
    
    private func setupViews() {
        [backButton, titleLabel, firstNameField, lastNameField, emailField, phoneField, updateButton].forEach(addSubview)
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
        
        firstNameField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(16)
                make.leading.trailing.height.equalTo(firstNameField)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(firstNameField)
        }

        phoneField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(firstNameField)
        }
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(270)
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(55)
        }
    }
}
