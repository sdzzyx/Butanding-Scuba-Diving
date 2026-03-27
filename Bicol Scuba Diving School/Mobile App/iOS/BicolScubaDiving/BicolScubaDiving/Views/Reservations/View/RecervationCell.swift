//
//  RecervationCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import UIKit
import SnapKit
import Kingfisher

class ReservationCell: UITableViewCell {
    
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = .primaryGrayTextColor
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let statusLabel: UILabel = {
            let label = UILabel()
            label.font = .roboto(.medium, size: 14)
            label.textColor = .primaryOrange
            return label
        }()
        
        private let priceLabel: UILabel = {
            let label = UILabel()
            label.font = .roboto(.medium, size: 16)
            label.textColor = .primaryBlueColor
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
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(priceLabel)
        
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
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
        
        statusLabel.snp.makeConstraints { make in
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
                    make.leading.equalTo(titleLabel.snp.leading)
                }
                
                priceLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(statusLabel.snp.centerY)
                    make.trailing.equalToSuperview().inset(12)
                }
    }
    
    // MARK: - Configure Cell
    func configure(with booking: Booking) {
        titleLabel.text = booking.packageName
        descriptionLabel.text = "Booking ID: \(booking.bookingId.prefix(8))"
                statusLabel.text = booking.status
        priceLabel.text = String(format: "₱%.2f", booking.price)
        
        if let url = URL(string: booking.imageUrl) {
            packageImageView.kf.setImage(with: url)
        } else {
            packageImageView.image = UIImage(named: "placeholder")
        }

        
//        if let imageUrl = booking.imageUrl, let url = URL(string: imageUrl) {
//                packageImageView.kf.setImage(with: url) // if using Kingfisher
//            } else {
//                packageImageView.image = UIImage(named: "placeholder")
//            }
//        titleLabel.text = package.title
//        descriptionLabel.text = package.description
//        if let url = URL(string: package.imageUrl) {
//            packageImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
//        }
    }
}
