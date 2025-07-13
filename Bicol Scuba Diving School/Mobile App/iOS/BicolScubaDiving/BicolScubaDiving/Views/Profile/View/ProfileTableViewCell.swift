//
//  ProfileTableViewCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/13/25.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    let button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(45)
        }
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 8
    }
}
