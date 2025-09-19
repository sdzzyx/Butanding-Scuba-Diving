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
    
    let tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.showsVerticalScrollIndicator = false
            return tableView
        }()
    
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
        addSubview(tableView)
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
        
        tableView.snp.makeConstraints { make in
                    make.top.equalTo(headerImageView.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalTo(continueButton.snp.top).offset(-12)
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
