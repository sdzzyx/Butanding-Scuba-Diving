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
        
        // Initial Default Screen 
        FirebaseAnalyticsManager.shared.logScreenView(screenName: AppConstant.Analytics.WelcomeScreen.screen(viewModel.currentSlideIndex), 
                                                      screenClass: String(describing: type(of: self)))
    }
    
    private func setupBindings() {
        viewModel.onCurrentSlideChanged = { [weak self] in
            guard let self = self else { return }
            self.onboardingView.pageControl.currentPage = self.viewModel.currentSlideIndex
            self.onboardingView.getStartedButton.isHidden = false
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
    
    
    @objc private func getStartedTapped() {
        print("Get Started button tapped")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Analytics
        FirebaseAnalyticsManager.shared.logEvent(name: AppConstant.Analytics.EventName.click,
                                                 parameters: [AppConstant.Analytics.Parameter.screen: AppConstant.Analytics.WelcomeScreen.screen(viewModel.currentSlideIndex),
                                                              AppConstant.Analytics.Parameter.buttonName: AppConstant.Analytics.WelcomeScreen.buttonGetStarted])
        
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
            cell.titleLabel.text = slide.title
            cell.subtitleLabel.text = slide.subtitle
            cell.descriptionLabel.text = slide.description
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
        
        // Set the current welcome screen page for the Analytics Screen
        FirebaseAnalyticsManager.shared.logScreenView(screenName: AppConstant.Analytics.WelcomeScreen.screen(currentPage), 
                                                      screenClass: String(describing: type(of: self)))
    }
}
