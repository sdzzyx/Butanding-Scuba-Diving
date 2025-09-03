//
//  PaymentMethodRow.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit

class PaymentMethodRow: UIView {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let radioButton = UIButton(type: .custom)
    
    init(iconName: String, title: String? = nil, iconSize: CGFloat = 100) {
        super.init(frame: .zero)
        setupUI(iconName: iconName, title: title, iconSize: iconSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(iconName: String, title: String?, iconSize: CGFloat) {
        backgroundColor = UIColor.primaryGrayLight.withAlphaComponent(0.4)
        layer.cornerRadius = 8
        
        iconImageView.image = UIImage(named: iconName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(iconSize)
        }
        
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        radioButton.setImage(
            UIImage(systemName: "circle")?.withTintColor(.primaryLightGrayColor, renderingMode: .alwaysOriginal),
            for: .normal
        )
        
        radioButton.setImage(
            UIImage(systemName: "circle.inset.filled")?.withTintColor(.primaryOrange, renderingMode: .alwaysOriginal),
            for: .selected
        )
        
        if let title = title {
            
            titleLabel.text = title
            titleLabel.font = UIFont.roboto(.medium, size: 16)
            titleLabel.textColor = .black
            
            let leftStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
            leftStack.axis = .horizontal
            leftStack.alignment = .center
            leftStack.spacing = 8
            
            let mainStack = UIStackView(arrangedSubviews: [leftStack, radioButton])
            mainStack.axis = .horizontal
            mainStack.alignment = .center
            mainStack.distribution = .equalSpacing
            
            addSubview(mainStack)
            mainStack.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
            
        } else {
            let mainStack = UIStackView(arrangedSubviews: [iconImageView, radioButton])
            mainStack.axis = .horizontal
            mainStack.alignment = .center
            mainStack.distribution = .equalSpacing
            
            addSubview(mainStack)
            mainStack.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
        }
    }
}
