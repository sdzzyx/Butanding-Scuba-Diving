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
    
    let firstNameButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(white: 0.95, alpha: 1)
        config.baseForegroundColor = .primaryGrayDarkTextColor
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let lastNameButton: UIButton = {
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
    }()
    
    let emailButton: UIButton = {
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
    }()
    
    let phoneButton: UIButton = {
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
    
    func highlightButton(_ button: UIButton) {
        
        [firstNameButton, lastNameButton, emailButton, phoneButton].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.primaryOrange.cgColor
        }
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.primaryOrange.cgColor
    }
    
    func activateUpdateButton() {
        updateButton.isEnabled = true
        updateButton.backgroundColor = .primaryOrange
    }
    
    func resetAllButtonHighlights() {
        [firstNameButton, lastNameButton, emailButton, phoneButton].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        
        updateButton.isEnabled = false
        updateButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func configure(with data: PersonalInformationViewData) {
        titleLabel.text = data.title
        firstNameButton.setTitle(data.firstNameTitle, for: .normal)
        lastNameButton.setTitle(data.lastNameTitle, for: .normal)
        emailButton.setTitle(data.emailTitle, for: .normal)
        phoneButton.setTitle(data.phoneTitle, for: .normal)
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
        
        firstNameButton.setAttributedTitle(NSAttributedString(
            string: data.firstNameTitle,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        lastNameButton.setAttributedTitle(NSAttributedString(
            string: data.lastNameTitle,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        emailButton.setAttributedTitle(NSAttributedString(
            string: data.emailTitle,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
        phoneButton.setAttributedTitle(NSAttributedString(
            string: data.phoneTitle,
            attributes: [.font: buttonFont]
        ), for: .normal)
        
    }
    
    
    
    // MARK: - Setup
    
    private func setupViews() {
        [backButton, titleLabel, firstNameButton, lastNameButton, emailButton, phoneButton, updateButton].forEach(addSubview)
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
        
        firstNameButton.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        lastNameButton.snp.makeConstraints { make in
            make.top.equalTo(firstNameButton.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(firstNameButton)
        }
        
        emailButton.snp.makeConstraints { make in
            make.top.equalTo(lastNameButton.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(firstNameButton)
        }
        
        phoneButton.snp.makeConstraints { make in
            make.top.equalTo(emailButton.snp.bottom).offset(16)
            make.leading.trailing.height.equalTo(firstNameButton)
        }
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(phoneButton.snp.bottom).offset(270)
            make.leading.trailing.equalTo(phoneButton)
            make.height.equalTo(55)
        }
    }
}
