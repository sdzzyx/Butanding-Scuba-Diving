//
//  HomeView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    
    // MARK: - Properties
    private let viewModel: HomeViewModel
    
    // Scroll container
    let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Public UI Elements
    let logoImageView = UIImageView()
    let notificationButton = UIButton(type: .system)
    let greetingLabel = UILabel()
    let subGreetingLabel = UILabel()
    let titleLabel = UILabel()
    let viewAllButton = UIButton(type: .system)
    let collectionView: UICollectionView
    let homeTitleLabel = UILabel()
    let homeSubtitleLabel = UILabel()
    let galleryCollectionView: UICollectionView
    
    private var galleryHeightConstraint: Constraint?
    
    // MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        // Dive Packages Layout
        let packageLayout = UICollectionViewFlowLayout()
        packageLayout.scrollDirection = .horizontal
        packageLayout.itemSize = CGSize(width: 180, height: 160)
        packageLayout.minimumLineSpacing = 16
        packageLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: packageLayout)
        
        // Gallery Layout
        let galleryLayout = UICollectionViewFlowLayout()
        galleryLayout.scrollDirection = .vertical
        galleryLayout.minimumLineSpacing = 12
        galleryLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: galleryLayout)
        galleryCollectionView.isScrollEnabled = false
        
        super.init(frame: .zero)
        setupUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Added scrollView & contentView
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Configure UI elements
        logoImageView.image = viewModel.logoImage
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        
        notificationButton.setImage(viewModel.notificationImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        notificationButton.imageView?.contentMode = .scaleAspectFit
        notificationButton.contentHorizontalAlignment = .fill
        notificationButton.contentVerticalAlignment = .fill
        
        greetingLabel.text = viewModel.greetingText
        greetingLabel.font = UIFont.roboto(.bold, size: 20)
        greetingLabel.textColor = .primaryOrange
        
        subGreetingLabel.text = viewModel.subGreetingText
        subGreetingLabel.font = UIFont.roboto(.regular, size: 15)
        subGreetingLabel.textColor = .primaryBlueColor
        
        titleLabel.text = viewModel.sectionTitleText
        titleLabel.font = UIFont.roboto(.bold, size: 16)
        titleLabel.textColor = .primaryBlueColor
        
        viewAllButton.setTitle(viewModel.viewAllButtonText, for: .normal)
        viewAllButton.setTitleColor(.primaryOrange, for: .normal)
        viewAllButton.titleLabel?.font = UIFont.roboto(.regular, size: 15)
        
        homeTitleLabel.attributedText = NSAttributedString.highlightedString(
            fullText: viewModel.homeTitleText,
            baseFont: UIFont.roboto(.bold, size: 25),
            baseColor: .primaryBlueColor,
            highlights: []
        )
        homeTitleLabel.textAlignment = .left
        
        homeSubtitleLabel.attributedText = NSAttributedString.highlightedString(
            fullText: viewModel.homeSubtitleText,
            baseFont: UIFont.roboto(.bold, size: 25),
            baseColor: .primaryBlueColor,
            highlights: [
                .init(
                    substring: "Gentle Giants",
                    font: UIFont.roboto(.bold, size: 25),
                    color: .primaryOrange
                )
            ]
        )
        homeSubtitleLabel.textAlignment = .left
        
        collectionView.register(PackageCell.self, forCellWithReuseIdentifier: PackageCell.identifier)
        collectionView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        galleryCollectionView.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.identifier)
        galleryCollectionView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        galleryCollectionView.showsHorizontalScrollIndicator = false
        
        // Added subviews to contentView
        [
            logoImageView, notificationButton,
            greetingLabel, subGreetingLabel,
            titleLabel, viewAllButton, collectionView,
            homeTitleLabel, homeSubtitleLabel, galleryCollectionView
        ].forEach { contentView.addSubview($0) }
    }
    
    // MARK: - Layout
    private func layoutUI() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(110)
        }
        
        notificationButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.right.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
        }
        
        subGreetingLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(4)
            make.left.equalTo(greetingLabel)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subGreetingLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
        }
        
        viewAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        homeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        homeSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(homeTitleLabel)
        }
        
        galleryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(homeSubtitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            galleryHeightConstraint = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func updateGalleryHeight(_ height: CGFloat) {
        galleryHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
}
