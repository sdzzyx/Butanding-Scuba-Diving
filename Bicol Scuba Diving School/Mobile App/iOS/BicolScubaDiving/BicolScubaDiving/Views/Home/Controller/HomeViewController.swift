//
//  HomeViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private lazy var homeView = HomeView(viewModel: viewModel)
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
        setupCollectionView()
        bindViewModel()
        viewModel.fetchPackages()
        viewModel.fetchHomepageData()
        viewModel.fetchHomepageDestinations()
        viewModel.fetchHomepageEvents()
        viewModel.fetchHomepageImages()
        setupHomepageImagesCollectionView()
        homeView.updateGreeting()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        
        homeView.galleryCollectionView.delegate = self
        homeView.galleryCollectionView.dataSource = self
        
        homeView.destinationCollectionView.delegate = self
        homeView.destinationCollectionView.dataSource = self
        
        homeView.eventCollectionView.delegate = self
        homeView.eventCollectionView.dataSource = self
        
        homeView.homepageImagesCollectionView.delegate = self
        homeView.homepageImagesCollectionView.dataSource = self

    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.homeView.collectionView.reloadData()
            }
        }
        
        viewModel.onGalleryFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.homeView.galleryCollectionView.reloadData()
                
                let galleryContentHeight = self.homeView.galleryCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.homeView.updateGalleryHeight(galleryContentHeight)
            }
        }
        
        viewModel.onDestinationsFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.homeView.destinationCollectionView.reloadData()
                
                // After reloading, compute and update dynamic height
//                let destinationContentHeight = self.homeView.destinationCollectionView.collectionViewLayout.collectionViewContentSize.height
//                self.homeView.updateDestinationHeight(destinationContentHeight)
            }
        }
        
        viewModel.onEventsFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.homeView.eventCollectionView.reloadData()
            }
        }
        
        viewModel.onGreetingUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.homeView.updateGreeting()
            }
        }
        
        viewModel.onHomepageImagesFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let data = self.viewModel.homepageImages else { return }
                
                self.homeView.homepageQuoteLabel.attributedText = self.makeHighlightedQuoteTitle(from: data.quote)
                self.homeView.homepageSubQuoteLabel.attributedText = self.makeHighlightedSubQuoteTitle(from: data.subQuote)
                
                self.homeView.homepageImagesCollectionView.reloadData()
                
                // Scroll to middle after reload
                let middleIndex = self.viewModel.homepageImagesRepeated.count / 2
                let middleIndexPath = IndexPath(item: middleIndex, section: 0)
                self.homeView.homepageImagesCollectionView.scrollToItem(
                    at: middleIndexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
    }
    
    private func makeHighlightedQuoteTitle(from text: String) -> NSAttributedString {
            let baseFont = UIFont.roboto(.bold, size: 20)
            let attributed = NSMutableAttributedString(
                string: text,
                attributes: [
                    .font: baseFont,
                    .foregroundColor: UIColor.primaryBlueColor
                ]
            )
            
            if let range = text.range(of: "underwater adventure") {
                attributed.addAttributes([
                    .foregroundColor: UIColor.primaryOrange
                ], range: NSRange(range, in: text))
            }
            return attributed
        }
        
        private func makeHighlightedSubQuoteTitle(from text: String) -> NSAttributedString {
            let baseFont = UIFont.roboto(.bold, size: 23)
            let attributed = NSMutableAttributedString(
                string: text,
                attributes: [
                    .font: baseFont,
                    .foregroundColor: UIColor.primaryBlueColor
                ]
            )
            
            if let range = text.range(of: "Discover.") {
                attributed.addAttributes([
                    .foregroundColor: UIColor.primaryOrange
                ], range: NSRange(range, in: text))
            }
            return attributed
        }
    
    // MARK: - Setup homepageImagesCollectionView
        private func setupHomepageImagesCollectionView() {
            if let layout = homeView.homepageImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 16
                    layout.itemSize = CGSize(width: 220, height: 160)

                    let inset = (UIScreen.main.bounds.width - 220) / 2
                    layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
                }

                homeView.homepageImagesCollectionView.decelerationRate = .fast
                homeView.homepageImagesCollectionView.isPagingEnabled = false
        }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.collectionView {
            return viewModel.numberOfItems()
        } else if collectionView == homeView.galleryCollectionView {
            return viewModel.galleryImages.count
        } else if collectionView == homeView.destinationCollectionView {
            return viewModel.allDestinations.count
        } else if collectionView == homeView.eventCollectionView {
            return viewModel.allEvents.count
        } else if collectionView == homeView.homepageImagesCollectionView {
            return viewModel.homepageImagesRepeated.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == homeView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCell.identifier, for: indexPath) as! PackageCell
            let package = viewModel.package(at: indexPath.item)
            cell.configure(with: package)
            return cell
        } else if collectionView == homeView.galleryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.identifier, for: indexPath) as! GalleryImageCell
            let imageUrl = viewModel.galleryImages[indexPath.item]
            cell.configure(with: imageUrl)
            return cell
        } else if collectionView == homeView.destinationCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.identifier, for: indexPath) as! DestinationCell
            let destination = viewModel.allDestinations[indexPath.item]
            cell.configure(with: destination)
            return cell
        } else if collectionView == homeView.eventCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as! EventCell
            let event = viewModel.allEvents[indexPath.item]
            cell.configure(with: event)
            return cell
        } else if collectionView == homeView.homepageImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.identifier, for: indexPath) as! GalleryImageCell
            let imageUrl = viewModel.homepageImagesRepeated[indexPath.item]
            cell.configure(with: imageUrl)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeView.collectionView {
            let package = viewModel.package(at: indexPath.item)
            
            // Small animation for feedback
            if let cell = collectionView.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.1,
                               animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                },
                               completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        cell.transform = .identity
                    }
                    self.homeView.delegate?.didSelectPackage(package)
                })
            } else {
                homeView.delegate?.didSelectPackage(package)
            }
        } else if collectionView == homeView.homepageImagesCollectionView {
            print("Selected homepage image index: \(indexPath.item % 4)") // %4 to get real index
        }
        else {
            print("Selected gallery image index: \(indexPath.item)")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeView.galleryCollectionView {
            let width = collectionView.frame.width - 32 // 16 padding each side
            return CGSize(width: width, height: 180)
        } else if collectionView == homeView.destinationCollectionView {
            return CGSize(width: 180, height: 140) // perfect small cards
        } else if collectionView == homeView.eventCollectionView {
            return CGSize(width: 180, height: 140)
        } else if collectionView == homeView.homepageImagesCollectionView {
            return CGSize(width: 220, height: 160)
        } else {
            return CGSize(width: 180, height: 160) // packages
        }
    }
}

// MARK: - Infinite Carousel Behavior
extension HomeViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == homeView.homepageImagesCollectionView else { return }
        
        let urlsCount = 4 // real images count
        let totalCount = viewModel.homepageImagesRepeated.count
        let middleIndex = totalCount / 2

        let layout = homeView.homepageImagesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let currentIndex = Int((scrollView.contentOffset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing)

        if currentIndex < urlsCount || currentIndex >= totalCount - urlsCount {
            let newIndexPath = IndexPath(item: middleIndex, section: 0)
            homeView.homepageImagesCollectionView.scrollToItem(
                at: newIndexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == homeView.homepageImagesCollectionView,
              let layout = homeView.homepageImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let offset = targetContentOffset.pointee.x + scrollView.contentInset.left

        let index = round(offset / cellWidthIncludingSpacing)
        targetContentOffset.pointee.x = index * cellWidthIncludingSpacing - scrollView.contentInset.left
        //targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left,
                                              //y: scrollView.contentInset.top)
    }
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    func didTapViewAll() {
        let packageVC = PackageViewController()
        navigationController?.pushViewController(packageVC, animated: true)
    }
    
    func didSelectPackage(_ package: DivePackage) {
            let detailViewModel = PackageDetailViewModel(package: package)
            let detailVC = PackageDetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
}
