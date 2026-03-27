//
//  InstructorScheduleCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/16/25.
//

import UIKit
import SnapKit
import Kingfisher

class InstructorScheduleCell: UITableViewCell {
    
    // MARK: - UI Components
        private let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .primaryGrayDisable
            view.layer.cornerRadius = 16
            return view
        }()
        
        private let packageImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .roboto(.bold, size: 18)
            label.textColor = .primaryBlueColor
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        private let bookingNumberLabel: UILabel = {
            let label = UILabel()
            label.font = .roboto(.medium, size: 14)
            label.textColor = .primaryOrange
            label.text = AppConstant.Instructor.bookingOneTitle
            return label
        }()
        
        // MARK: - Init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            backgroundColor = .clear
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }
        
        private func setupUI() {
            contentView.addSubview(containerView)
            containerView.addSubview(packageImageView)
            containerView.addSubview(titleLabel)
            containerView.addSubview(bookingNumberLabel)
            
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
            
            packageImageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(12)
                make.width.equalTo(120)
                make.height.equalTo(100)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(packageImageView.snp.top)
                make.leading.equalTo(packageImageView.snp.trailing).offset(12)
                make.trailing.equalToSuperview().inset(12)
            }
            
            bookingNumberLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.equalTo(titleLabel.snp.leading)
                make.trailing.equalToSuperview().inset(12)
                make.bottom.lessThanOrEqualToSuperview().inset(12)
            }
        }
        
        // MARK: - Configure Cell
    func configure(title: String, imageUrl: String, bookingNumber: String) {
        titleLabel.text = title
        bookingNumberLabel.text = bookingNumber
        if let url = URL(string: imageUrl) {
            packageImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }

    
//        func configure(with package: DivePackage, bookingNumber: String) {
//            titleLabel.text = package.title
//            bookingNumberLabel.text = bookingNumber
//            if let url = URL(string: package.imageUrl) {
//                packageImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
//            }
//        }
}
