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
    
    // MARK: - Scrollable Content
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
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
    
    let requirementsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.PackagesDetail.requirementsTitle
        label.font = .roboto(.bold, size: 16)
        return label
    }()
    
    let requirementsLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = .darkGray
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
        let button = CustomButton()
        button.setTitle(AppConstant.PackagesDetail.bookButtonTitle, for: .normal)
        button.isEnabled = true
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
        addSubview(scrollView)
        addSubview(bookButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(requirementsTitleLabel)
        contentView.addSubview(requirementsLabel)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(slotTitleLabel)
        contentView.addSubview(slotLabel)
        
        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        bookButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bookButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
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
        
        requirementsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        requirementsLabel.snp.makeConstraints { make in
            make.top.equalTo(requirementsTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(requirementsLabel.snp.bottom).offset(25)
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
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with viewModel: PackageDetailViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        slotLabel.text = viewModel.slotAvailable
        headerImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        
        // Build bullet points with proper indentation
        let nonEmptyRequirements = viewModel.requirements.filter {
            !$0.trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        if !nonEmptyRequirements.isEmpty {
            let bulletPoints = nonEmptyRequirements.map { "• \($0)" }.joined(separator: "\n")
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineSpacing = 4
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.headIndent = 10
            
            let attributedString = NSAttributedString(
                string: bulletPoints,
                attributes: [
                    .font: UIFont.roboto(.regular, size: 14),
                    .foregroundColor: UIColor.darkGray,
                    .paragraphStyle: paragraphStyle
                ]
            )
            
            requirementsLabel.attributedText = attributedString
            requirementsTitleLabel.isHidden = false
            requirementsLabel.isHidden = false
        } else {
            requirementsTitleLabel.isHidden = true
            requirementsLabel.isHidden = true
        }
    }
}
