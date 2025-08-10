//
//  PackageViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import Foundation
import FirebaseFirestore

final class HomeViewModel {
    
    // MARK: - Data Properties
    private(set) var packages: [DivePackage] = []
    var onDataUpdated: (() -> Void)?
    
    var galleryImages: [String] = []
    var onGalleryFetched: (() -> Void)?
    
    // MARK: - Firestore Data Fetch
    func fetchPackages() {
        FirestoreService.shared.fetchDivePackages { [weak self] packages in
            self?.packages = packages
            self?.onDataUpdated?()
        }
    }
    
    func fetchHomepageData() {
        FirestoreService.shared.fetchHomepageData { [weak self] gallery in
            self?.galleryImages = gallery
            self?.onGalleryFetched?()
        }
    }
    
    // MARK: - Packages Helpers
    func numberOfItems() -> Int {
        return packages.count
    }
    
    func package(at index: Int) -> DivePackage {
        return packages[index]
    }
    
    // MARK: - UI Configuration (from AppConstant)
    var logoImage: UIImage? {
        return UIImage(named: AppConstant.Home.logoImageName)
    }
    
    var notificationImage: UIImage? {
        return UIImage(named: AppConstant.Home.notificationImageName)
    }
    
    var greetingText: String {
        return AppConstant.Home.greetingText
    }
    
    var subGreetingText: String {
        return AppConstant.Home.subGreetingText
    }
    
    var sectionTitleText: String {
        return AppConstant.Home.sectionTitle
    }
    
    var viewAllButtonText: String {
        return AppConstant.Home.viewAllButtonText
    }
    
    var homeTitleText: String {
        return AppConstant.Home.title
    }
    
    var homeSubtitleText: String {
        return AppConstant.Home.subtitle
    }
}
