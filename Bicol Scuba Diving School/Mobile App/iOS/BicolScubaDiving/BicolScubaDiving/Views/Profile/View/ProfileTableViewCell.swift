//
//  ProfileTableViewCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/13/25.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContainerView()
        setUpLabel()
        setupBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.backgroundColor = UIColor.primaryGrayDisableBackground
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    private func setUpLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.roboto(.medium, size: 13)
        titleLabel.textColor = .black
    }
    
    private func setupBackgroundView() {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        selectedBackgroundView = bgView
    }
}
