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
        setupCollectionView()
        bindViewModel()
        viewModel.fetchPackages()
        viewModel.fetchHomepageData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        
        homeView.galleryCollectionView.delegate = self
        homeView.galleryCollectionView.dataSource = self
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
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.collectionView {
            return viewModel.numberOfItems()
        } else {
            return viewModel.galleryImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == homeView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCell.identifier, for: indexPath) as! PackageCell
            let package = viewModel.package(at: indexPath.item)
            cell.configure(with: package)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.identifier, for: indexPath) as! GalleryImageCell
            let imageUrl = viewModel.galleryImages[indexPath.item]
            cell.configure(with: imageUrl)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeView.collectionView {
            print("Selected package: \(viewModel.package(at: indexPath.item).title)")
        } else {
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
        } else {
            return CGSize(width: 180, height: 160) // package cells
        }
    }
}
