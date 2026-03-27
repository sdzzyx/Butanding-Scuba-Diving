//
//  PaymentMethodCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/8/25.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
    static let identifier = "PaymentMethodCell"
    
    let methodRow: PaymentMethodContentView
    
    init(method: PaymentMethod) {
        self.methodRow = PaymentMethodContentView(iconName: method.iconName,
                                          title: method.title,
                                          iconSize: method.iconSize)
        super.init(style: .default, reuseIdentifier: PaymentMethodCell.identifier)
        contentView.addSubview(methodRow)
        methodRow.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

