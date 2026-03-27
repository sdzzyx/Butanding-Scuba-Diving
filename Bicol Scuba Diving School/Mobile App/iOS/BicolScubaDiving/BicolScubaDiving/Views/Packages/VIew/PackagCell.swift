//
//  PackagCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/20/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PackagesCell: UITableViewCell {
    
    static let identifier = "PackagesCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondarySystemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 12)
        return view
    }()
    
    private let packageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.bold, size: 18)
        label.textColor = .primaryBlueColor
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = .primaryGrayTextColor
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(packageImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        packageImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(packageImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configure
    func configure(with package: DivePackage) {
        titleLabel.text = package.title
        descriptionLabel.text = package.description
        packageImageView.kf.setImage(with: URL(string: package.imageUrl))
    }
}
