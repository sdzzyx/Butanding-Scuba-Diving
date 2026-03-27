//
//  BookingDetailView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/16/25.
//

import UIKit
import SnapKit

class InstructorBookingDetailView: UIView {
    
    var onCompletedTapped: (() -> Void)?

    
    // MARK: - UI Components
        let backButton: UIButton = {
            let button = UIButton()
            button.imageView?.contentMode = .scaleAspectFit   // ensures proper scaling
            button.enableTapAnimation() // optional — same as in SignUpView
            return button
        }()
        
        private let headerTitleLabel: UILabel = {
            let label = UILabel()
            label.text = AppConstant.Instructor.bookingDetailsTitle
            label.font = .roboto(.bold, size: 28)
            label.textAlignment = .right
            return label
        }()
        
        private let infoStack = UIStackView()
    
    private let completedButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(AppConstant.Instructor.buttonTitle, for: .normal)
        button.isEnabled = true
        return button
    }()

        
        // MARK: - Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
            configureHeaderTitle()
            configureBackButtonImage()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
            configureHeaderTitle()
            configureBackButtonImage()
        }
        
        // MARK: - Setup UI
        private func setupUI() {
            backgroundColor = .systemBackground
            
            addSubview(backButton)
            addSubview(headerTitleLabel)
            addSubview(infoStack)
            addSubview(completedButton)
            completedButton.addTarget(self, action: #selector(handleCompletedTapped), for: .touchUpInside)
            
            infoStack.axis = .vertical
            infoStack.spacing = 15
            
            backButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(65)
                make.leading.equalToSuperview().offset(15)
                make.width.height.equalTo(70)
            }
            
            headerTitleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(backButton)
                make.leading.equalTo(backButton.snp.trailing).offset(8)
                make.trailing.equalToSuperview().inset(16)
            }
            
            infoStack.snp.makeConstraints { make in
                make.top.equalTo(headerTitleLabel.snp.bottom).offset(40)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            completedButton.snp.makeConstraints { make in
                make.top.equalTo(infoStack.snp.bottom).offset(50)
                make.leading.trailing.equalToSuperview().inset(25)
                make.height.equalTo(55)
            }

        }
        
        // MARK: - Configure Back Button Image
        private func configureBackButtonImage() {
            if let originalImage = UIImage(named: AppConstant.Instructor.backLogo) {
                let desiredSize = CGSize(width: 65, height: 65)
                if let resizedImage = originalImage.resized(to: desiredSize) {
                    backButton.setImage(resizedImage, for: .normal)
                } else {
                    backButton.setImage(originalImage, for: .normal)
                }
            }
        }
        
        // MARK: - Configure Header Title (Blue + Orange)
        private func configureHeaderTitle() {
            let fullText = AppConstant.Instructor.bookingDetailsTitle 
            let attributedText = NSMutableAttributedString(
                string: fullText,
                attributes: [
                    .font: UIFont.roboto(.bold, size: 28),
                    .foregroundColor: UIColor.primaryBlueColor
                ]
            )
            
            if let range = fullText.range(of: "Details") {
                let nsRange = NSRange(range, in: fullText)
                attributedText.addAttribute(.foregroundColor, value: UIColor.primaryOrange, range: nsRange)
            }
            
            headerTitleLabel.attributedText = attributedText
        }
        
        // MARK: - Configure
        func configure(with viewModel: BookingDetailViewModel) {
            infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            func makeRow(title: String, value: String) -> UIView {
                let row = UIStackView()
                row.axis = .horizontal
                row.distribution = .equalSpacing
                
                let leftLabel = UILabel()
                leftLabel.text = title
                leftLabel.font = .roboto(.medium, size: 16)
                leftLabel.textColor = .black
                
                let rightLabel = UILabel()
                rightLabel.text = value
                rightLabel.font = .roboto(.bold, size: 16)
                rightLabel.textColor = .primaryOrange
                rightLabel.textAlignment = .right
                
                row.addArrangedSubview(leftLabel)
                row.addArrangedSubview(rightLabel)
                return row
            }
            
            let sectionTitle = UILabel()
            sectionTitle.text = AppConstant.Instructor.packageInformationTitle
            sectionTitle.font = .roboto(.bold, size: 18)
            sectionTitle.textColor = .primaryBlueColor
            infoStack.addArrangedSubview(sectionTitle)
            
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.bookingNumberTitle, value: viewModel.bookingNumber))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.packageTitle, value: viewModel.packageName))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.nameTitle, value: viewModel.name))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.dateTimeTitle, value: viewModel.dateTime))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.emailTitle, value: viewModel.email))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.Instructor.phoneNumberTitle, value: viewModel.phoneNumber))
            
            let participantsLabel = UILabel()
            participantsLabel.text = AppConstant.Instructor.participantsTitle
            participantsLabel.font = .roboto(.bold, size: 18)
            participantsLabel.textColor = .primaryBlueColor
            infoStack.addArrangedSubview(participantsLabel)
            
            for name in viewModel.participants {
                let nameLabel = UILabel()
                nameLabel.text = name
                nameLabel.font = .roboto(.regular, size: 16)
                nameLabel.textColor = .primaryOrange
                infoStack.addArrangedSubview(nameLabel)
            }
        }
    
    @objc private func handleCompletedTapped() {
        onCompletedTapped?()
    }

}


