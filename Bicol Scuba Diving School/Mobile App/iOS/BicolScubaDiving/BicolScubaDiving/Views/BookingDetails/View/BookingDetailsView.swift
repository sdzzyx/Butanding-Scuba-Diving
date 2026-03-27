//
//  BookingDetailsView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/24/25.
//

import UIKit
import SnapKit

class BookingDetailsView: UIView {
    // MARK: - Callbacks
        var onBackTapped: (() -> Void)?
    
    var onCancelTapped: (() -> Void)?
        
        // MARK: - UI Components
        let backButton: UIButton = {
            let button = UIButton()
            button.imageView?.contentMode = .scaleAspectFit
            button.enableTapAnimation()
            return button
        }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(AppConstant.BookingDetails.buttonTitle, for: .normal)
        button.isEnabled = true
        return button
    }()
        
        private let headerTitleLabel: UILabel = {
            let label = UILabel()
            let fullText = AppConstant.BookingDetails.bookingDetailsTitle
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
            label.attributedText = attributedText
            label.textAlignment = .right
            return label
        }()
        
        let packageNameLabel = UILabel()
        let statusLabel = UILabel()
        let bookingNumberTitleLabel = UILabel()
        let bookingNumberValueLabel = UILabel()
        let dateTitleLabel = UILabel()
        let dateValueLabel = UILabel()
        let priceTitleLabel = UILabel()
        let priceValueLabel = UILabel()
    let instructorValueLabel = UILabel()
    let rescheduleReasonTitleLabel = UILabel()
    let rescheduleReasonValueLabel = UILabel()
    let rescheduleDateValueLabel = UILabel()


        private let infoStack = UIStackView()
        
        // MARK: - Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
            configureBackButtonImage()
            configureLabels()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
            configureBackButtonImage()
            configureLabels()
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            backgroundColor = .systemBackground
            
            addSubview(backButton)
            addSubview(headerTitleLabel)
            addSubview(infoStack)
            addSubview(cancelButton)
            
            backButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(65)
                make.leading.equalToSuperview().offset(15)
                make.width.height.equalTo(65) 
            }
            
            headerTitleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(backButton)
                make.leading.equalTo(backButton.snp.trailing).offset(8)
                make.trailing.equalToSuperview().inset(16)
            }
            
            infoStack.axis = .vertical
            infoStack.spacing = 15
            addSubview(infoStack)
            
            infoStack.snp.makeConstraints { make in
                make.top.equalTo(headerTitleLabel.snp.bottom).offset(40)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(infoStack.snp.bottom).offset(50)
                make.leading.trailing.equalToSuperview().inset(25)
                make.height.equalTo(55)
            }
            
            backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        }
        
        private func configureBackButtonImage() {
            if let originalImage = UIImage(named: AppConstant.BookingDetails.backLogo) {
                let desiredSize = CGSize(width: 65, height: 65)
                if let resizedImage = originalImage.resized(to: desiredSize) {
                    backButton.setImage(resizedImage, for: .normal)
                } else {
                    backButton.setImage(originalImage, for: .normal)
                }
            }
        }
        
        private func configureLabels() {
            packageNameLabel.font = .roboto(.bold, size: 18)
            packageNameLabel.textColor = .primaryBlueColor
            
            statusLabel.font = .roboto(.bold, size: 18)
            statusLabel.textColor = .primaryOrange
            statusLabel.textAlignment = .right
            
            func makeRow(title: String, valueLabel: UILabel) -> UIView {
                let row = UIStackView()
                row.axis = .horizontal
                row.distribution = .equalSpacing
                
                let titleLabel = UILabel()
                titleLabel.text = title
                titleLabel.font = .roboto(.medium, size: 16)
                titleLabel.textColor = .black
                
                //let valueLabel = UILabel()
                //valueLabel.text = value
                valueLabel.font = .roboto(.bold, size: 16)
                valueLabel.textColor = .primaryOrange
                valueLabel.textAlignment = .right
                
                row.addArrangedSubview(titleLabel)
                row.addArrangedSubview(valueLabel)
                return row
            }
            
            // Section rows
            let headerRow = UIStackView(arrangedSubviews: [packageNameLabel, statusLabel])
            headerRow.axis = .horizontal
            headerRow.distribution = .equalSpacing
            infoStack.addArrangedSubview(headerRow)
            
            infoStack.addArrangedSubview(makeRow(title: AppConstant.BookingDetails.bookingNumberTitle,
                                                     valueLabel: bookingNumberValueLabel))
                infoStack.addArrangedSubview(makeRow(title: AppConstant.BookingDetails.dateTitle,
                                                     valueLabel: dateValueLabel))
                infoStack.addArrangedSubview(makeRow(title: AppConstant.BookingDetails.priceTitle,
                                                     valueLabel: priceValueLabel))
            infoStack.addArrangedSubview(makeRow(title: AppConstant.BookingDetails.assignedInstructor,
                                                 valueLabel: instructorValueLabel))
            
            infoStack.addArrangedSubview(makeRow(title: "Reschedule Date:",
                                                     valueLabel: rescheduleDateValueLabel))

            infoStack.addArrangedSubview(makeRow(title: "Reschedule Reason:", valueLabel: rescheduleReasonValueLabel))



                cancelButton.addTarget(self, action: #selector(handleCancelTapped), for: .touchUpInside)
        }
        
        // MARK: - Actions
        @objc private func handleBackTapped() {
            onBackTapped?()
        }
    
    // MARK: - Cancel Tapped
    @objc private func handleCancelTapped() {
        onCancelTapped?()
    }
    
}
