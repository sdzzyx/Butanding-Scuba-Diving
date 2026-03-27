//
//  CashConfirmationView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/30/25.
//

import UIKit
import SnapKit

final class CashConfirmationView: UIView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppConstant.CashConfirmation.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.CashConfirmation.bookingHeader
        label.font = UIFont.roboto(.bold, size: 25)
        label.textColor = .primaryOrange
        label.textAlignment = .center
        return label
    }()
    
    private let thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.CashConfirmation.thankYouLabel
        label.font = UIFont.roboto(.medium, size: 18)
        label.textColor = .primaryBlueColor
        label.textAlignment = .center
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.CashConfirmation.details
        label.font = UIFont.roboto(.medium, size: 18)
        label.textColor = .primaryBlueColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let homeButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(AppConstant.CashConfirmation.homeButtonTitle, for: .normal)
        button.isEnabled = true // Active by default
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(logoImageView)
        addSubview(headerLabel)
        addSubview(thankYouLabel)
        addSubview(detailsLabel)
        addSubview(homeButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(120) // adjust spacing
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120) // logo size
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        thankYouLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(thankYouLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }

        homeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(detailsLabel.snp.bottom).offset(50)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
        }

    }
}
