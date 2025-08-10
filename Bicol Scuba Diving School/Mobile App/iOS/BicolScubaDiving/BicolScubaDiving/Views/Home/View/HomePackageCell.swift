//
//  HomePackageCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PackageCell: UICollectionViewCell {
    static let identifier = "PackageCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = UIFont.roboto(.bold, size: 14)
        titleLabel.numberOfLines = 1
        
        descriptionLabel.font = UIFont.roboto(.regular, size: 12)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .secondaryLabel
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    // MARK: - Configuration
    func configure(with package: DivePackage) {
        titleLabel.text = package.title
        descriptionLabel.text = package.description
        
        if let url = URL(string: package.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}
