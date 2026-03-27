//
//  PaymentSectionHeaderView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/8/25.
//

import UIKit

class PaymentSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "PaymentSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.roboto(.bold, size: 16)
        label.textColor = .primaryBlueColor
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

