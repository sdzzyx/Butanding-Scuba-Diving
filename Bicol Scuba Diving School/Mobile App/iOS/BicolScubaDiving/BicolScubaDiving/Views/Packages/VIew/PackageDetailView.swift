//
//  PackageDetailView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PackageDetailView: UIView {
    
    // MARK: - UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.bold, size: 22)
        label.textColor = .primaryBlueColor
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.PackagesDetail.descriptionTitle
        label.font = .roboto(.bold, size: 16)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.PackagesDetail.priceTitle
        label.font = .roboto(.bold, size: 16)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.bold, size: 16)
        label.textColor = .primaryOrange
        return label
    }()
    
    let slotTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.PackagesDetail.slotTitle
        label.font = .roboto(.bold, size: 16)
        return label
    }()
    
    let slotLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.bold, size: 16)
        label.textColor = .primaryOrange
        return label
    }()
    
    let bookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstant.PackagesDetail.bookButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryOrange
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .roboto(.bold, size: 16)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(headerImageView)
        addSubview(titleLabel)
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
        addSubview(priceTitleLabel)
        addSubview(priceLabel)
        addSubview(slotTitleLabel)
        addSubview(slotLabel)
        addSubview(bookButton)
        
        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        slotTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        slotLabel.snp.makeConstraints { make in
            make.top.equalTo(slotTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bookButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(slotTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configure(with viewModel: PackageDetailViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        slotLabel.text = viewModel.slotAvailable
        headerImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
    }
}
