//
//  OnBoardingView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/18/25.
//

import UIKit

class OnboardingView: UIView {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
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

        [titleLabel, subtitleLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            addSubview($0)
        }

        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = .orange
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .italicSystemFont(ofSize: 18)
        subtitleLabel.textColor = .customBlue

        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        pageControl.currentPageIndicatorTintColor = .orange

        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(getStartedButton)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            titleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            pageControl.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -70),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10),

            getStartedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            getStartedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50),
            getStartedButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
