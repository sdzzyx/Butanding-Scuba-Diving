//
//  OnBoardingViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/9/25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var completionHandler: (() -> Void)?
    private var viewModel = OnboardingViewModel()
    private let onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupCollectionView()
        onboardingView.getStartedButton.setTitle(viewModel.getStartedButtonTitle, for: .normal)
        onboardingView.getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        onboardingView.pageControl.numberOfPages = viewModel.numberOfSlides
        updateSlideContent(for: 0)
    }
    
    private func setupBindings() {
        viewModel.onCurrentSlideChanged = { [weak self] in
            guard let self = self else { return }
            self.updateSlideContent(for: self.viewModel.currentSlideIndex)
        }
    }
    
    private func setupCollectionView() {
        onboardingView.collectionView.dataSource = self
        onboardingView.collectionView.delegate = self
        onboardingView.collectionView.register(
            OnboardingImageCell.self,
            forCellWithReuseIdentifier: OnboardingImageCell.reuseIdentifier
        )
    }
    
    private func updateSlideContent(for index: Int) {
        guard let slide = viewModel.slide(at: index) else { return }
        onboardingView.titleLabel.text = slide.title
        onboardingView.subtitleLabel.text = slide.subtitle
        onboardingView.descriptionLabel.text = slide.description
        onboardingView.pageControl.currentPage = index
        onboardingView.getStartedButton.isHidden = index != viewModel.numberOfSlides - 1
    }
    
    @objc private func getStartedTapped() {
        print("Get Started button tapped")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        completionHandler?()
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSlides
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingImageCell.reuseIdentifier,
            for: indexPath
        ) as! OnboardingImageCell
        
        if let slide = viewModel.slide(at: indexPath.item) {
            cell.imageView.image = slide.image
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        viewModel.setCurrentSlide(to: currentPage)
    }
}
