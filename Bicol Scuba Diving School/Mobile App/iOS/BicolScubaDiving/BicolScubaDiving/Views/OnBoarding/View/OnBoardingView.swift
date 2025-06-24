//
//  OnBoardingView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/18/25.
//

import UIKit
import SnapKit

class OnboardingView: UIView {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let pageControl = CustomPageControl()
    
    let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Let’s Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(descriptionLabel)
        addSubview(pageControl)
        addSubview(getStartedButton)
        
        [titleLabel, subtitleLabel, descriptionLabel].forEach {
            $0.textAlignment = .center
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = .orange
        titleLabel.numberOfLines = 0
        
        subtitleLabel.font = .italicSystemFont(ofSize: 18)
        subtitleLabel.textColor = .customBlue
        
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        pageControl.currentPageIndicatorTintColor = .orange
        
        // MARK: - SnapKit Constraints
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        getStartedButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(getStartedButton.snp.top).offset(-70)
            make.height.equalTo(10)
        }
    }
}

