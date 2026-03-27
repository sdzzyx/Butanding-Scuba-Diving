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
    weak var delegate: HomeViewDelegate?
    
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
    let otherDestinationTitleLabel = UILabel()
    let destinationCollectionView: UICollectionView
    let eventTitleLabel = UILabel()
    let eventCollectionView: UICollectionView
    let homepageQuoteLabel = UILabel()
    let homepageSubQuoteLabel = UILabel()
    let homepageImagesCollectionView: UICollectionView
    
    private var galleryHeightConstraint: Constraint?
    private var destinationHeightConstraint: Constraint?
    private var eventHeightConstraint: Constraint?
    
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
        
        // Destination Images Layout
        let destinationLayout = UICollectionViewFlowLayout()
        destinationLayout.scrollDirection = .horizontal
        destinationLayout.minimumLineSpacing = 12
        destinationLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        destinationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: destinationLayout)
        destinationCollectionView.showsHorizontalScrollIndicator = false
        
        // Event Images Layout
        let eventLayout = UICollectionViewFlowLayout()
        eventLayout.scrollDirection = .horizontal
        eventLayout.minimumLineSpacing = 12
        eventLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: eventLayout)
        eventCollectionView.showsHorizontalScrollIndicator = false
        
        // Horizontal carousel for homepage images
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.minimumLineSpacing = 16
        homepageImagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        homepageImagesCollectionView.showsHorizontalScrollIndicator = false
        homepageImagesCollectionView.backgroundColor = .clear

        
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
        viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped), for: .touchUpInside)
        
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
        
        homepageQuoteLabel.font = UIFont.roboto(.bold, size: 20)
        homepageQuoteLabel.textColor = .primaryBlueColor
        homepageQuoteLabel.textAlignment = .center
        homepageQuoteLabel.numberOfLines = 0
        
        homepageSubQuoteLabel.font = UIFont.roboto(.bold, size: 23)
        homepageSubQuoteLabel.textColor = .primaryOrange
        homepageSubQuoteLabel.textAlignment = .center
        homepageSubQuoteLabel.numberOfLines = 0
        
        
        if let layout = homepageImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 16
        }
        homepageImagesCollectionView.decelerationRate = .fast
        homepageImagesCollectionView.isPagingEnabled = false
        homepageImagesCollectionView.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.identifier)
        homepageImagesCollectionView.backgroundColor = .clear
        homepageImagesCollectionView.showsHorizontalScrollIndicator = false
        
        // Added subviews to contentView
        [
            logoImageView, notificationButton,
            greetingLabel, subGreetingLabel,
            titleLabel, viewAllButton, collectionView,
            homeTitleLabel, homeSubtitleLabel, galleryCollectionView,
            homepageQuoteLabel, homepageImagesCollectionView, homepageSubQuoteLabel
        ].forEach { contentView.addSubview($0) }
        
        
        otherDestinationTitleLabel.text = AppConstant.Home.destinationTitle
        otherDestinationTitleLabel.font = UIFont.roboto(.bold, size: 16)
        otherDestinationTitleLabel.textColor = .primaryBlueColor

        destinationCollectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.identifier)
        destinationCollectionView.backgroundColor = .clear

        contentView.addSubview(otherDestinationTitleLabel)
        contentView.addSubview(destinationCollectionView)
        
        
        eventTitleLabel.text = AppConstant.Home.eventTitle
        eventTitleLabel.font = UIFont.roboto(.bold, size: 16)
        eventTitleLabel.textColor = .primaryBlueColor
        
        eventCollectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
        eventCollectionView.backgroundColor = .clear
        
        contentView.addSubview(eventTitleLabel)
        contentView.addSubview(eventCollectionView)
    }
    
    @objc private func viewAllButtonTapped() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.viewAllButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.viewAllButton.transform = .identity
            }
            // Call delegate after animation
            self.delegate?.didTapViewAll()
        })
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
            //make.bottom.equalToSuperview().offset(-20)
        }
        
        otherDestinationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(galleryCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
        }

        destinationCollectionView.snp.makeConstraints { make in
            make.top.equalTo(otherDestinationTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            //make.bottom.equalToSuperview().offset(-20)
        }
        
        eventTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        eventCollectionView.snp.makeConstraints { make in
            make.top.equalTo(eventTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            //make.bottom.equalToSuperview().offset(-20)
        }
        
        homepageQuoteLabel.snp.makeConstraints { make in
            make.top.equalTo(eventCollectionView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        homepageImagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(homepageQuoteLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        homepageSubQuoteLabel.snp.makeConstraints { make in
            make.top.equalTo(homepageImagesCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }

    }
    
    func updateGalleryHeight(_ height: CGFloat) {
        galleryHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
    
    func updateDestinationHeight(_ height: CGFloat) {
        destinationHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
    
    func updateEventHeight(_ height: CGFloat) {
        eventHeightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
    
    func updateGreeting() {
        greetingLabel.text = viewModel.greetingText
    }
}

protocol HomeViewDelegate: AnyObject {
    func didTapViewAll()
    func didSelectPackage(_ package: DivePackage)
}
