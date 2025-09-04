//
//  PaymentView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit
import SnapKit

class PaymentView: UIView {
    
    // MARK: UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppConstant.Payment.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        let highlights = [
            NSAttributedString.HighlightStyle(
                substring: AppConstant.Payment.paymentHighlightsTitle,
                font: .roboto(.bold, size: 28),
                color: .primaryBlueColor
            ),
            NSAttributedString.HighlightStyle(
                substring: AppConstant.Payment.methodHighlightsTitle,
                font: .roboto(.bold, size: 28),
                color: .primaryOrange
            )
        ]
        
        let attrText = NSAttributedString.highlightedString(
            fullText: AppConstant.Payment.paymentTitle,
            baseFont: .roboto(.bold, size: 28),
            baseColor: .black,
            highlights: highlights
        )
        
        label.attributedText = attrText
        
        return label
    }()
    
    let cashLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.Payment.cashTitle
        label.font = UIFont.roboto(.bold, size: 16)
        label.textColor = .primaryBlueColor
        return label
    }()
    
    let morePaymentOptionsLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.Payment.morePaymentOptionsTitle
        label.font = UIFont.roboto(.bold, size: 16)
        label.textColor = .primaryBlueColor
        return label
    }()
    
    let cashRow = PaymentMethodRow(
        iconName: AppConstant.Payment.cashLogo,
        title: AppConstant.Payment.cashPaymentTitle,
        iconSize: 30
    )
    
    let gcashRow = PaymentMethodRow(
        iconName: AppConstant.Payment.gcashLogo,
        title: nil,
        iconSize: 100
    )
    
    let paypalRow = PaymentMethodRow(
        iconName: AppConstant.Payment.paypalLogo,
        title: nil,
        iconSize: 100
    )
    
    let activityIndicator: UIActivityIndicatorView = {
        let indiator = UIActivityIndicatorView(style: .large)
        indiator.color = .primaryOrange
        indiator.hidesWhenStopped = true
        return indiator
    }()
    
    let continueButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(AppConstant.Payment.continueButtonTitle, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .primaryGrayLight
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(headerImageView)
        addSubview(headerTitleLabel)
        addSubview(activityIndicator)
        addSubview(cashLabel)
        addSubview(cashRow)
        addSubview(morePaymentOptionsLabel)
        addSubview(gcashRow)
        addSubview(paypalRow)
        addSubview(continueButton)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.greaterThanOrEqualTo(headerImageView.snp.trailing).offset(8)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(25)
        }
        
        cashRow.snp.makeConstraints { make in
            make.top.equalTo(cashLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        morePaymentOptionsLabel.snp.makeConstraints { make in
            make.top.equalTo(cashRow.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        gcashRow.snp.makeConstraints { make in
            make.top.equalTo(morePaymentOptionsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        paypalRow.snp.makeConstraints { make in
            make.top.equalTo(gcashRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension PaymentView {
    func setContinueButtonEnabled(_ isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.backgroundColor = isEnabled ? .primaryOrange : .primaryGrayLight
    }
}
