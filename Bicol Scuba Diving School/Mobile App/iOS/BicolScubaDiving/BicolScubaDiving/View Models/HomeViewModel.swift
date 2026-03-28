//
//  PackageViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class HomeViewModel {
    
    // MARK: - Data Properties
    private(set) var packages: [DivePackage] = []
    var onDataUpdated: (() -> Void)?
    
    private(set) var destinations: [HomepageDestination] = []
    var onDestinationsFetched: (() -> Void)?
    
    private(set) var events: [HomepageEvent] = []
    var onEventsFetched: (() -> Void)?
    
    var homepageImages: HomePageImages?
    var onHomepageImagesFetched: (() -> Void)?
    
    var galleryImages: [String] = []
    var onGalleryFetched: (() -> Void)?
    
    // Callback when greeting should refresh
    var onGreetingUpdated: (() -> Void)?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: User Greeting
    var greetingText: String {
        if let user = Auth.auth().currentUser {
            if let displayName = user.displayName, !displayName.isEmpty {
                // Take only the first word (before any space)
                let firstName = displayName.components(separatedBy: " ").first ?? displayName
                return "\(AppConstant.Home.greetingText) \(firstName)!"
            } else if let email = user.email {
                // Fallback: take the part before '@'
                let firstPart = email.components(separatedBy: "@").first ?? email
                return "\(AppConstant.Home.greetingText) \(firstPart)!"
            }
        }
        return "\(AppConstant.Home.greetingText)!"
    }
    
    var subGreetingText: String {
        return AppConstant.Home.subGreetingText
    }
    
    // MARK: - Init / Deinit
    init() {
        observeAuthChanges()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func observeAuthChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            self?.onGreetingUpdated?()
        }
    }
    
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
    
    func fetchHomepageDestinations() {
        FirestoreService.shared.fetchHomepageDestinations { [weak self] destinations in
            self?.destinations = destinations
            self?.onDestinationsFetched?()
        }
    }
    
    func fetchHomepageEvents() {
        FirestoreService.shared.fetchHomepageEvents { [weak self] events in
            self?.events = events
            self?.onEventsFetched?()
        }
    }
    
    func fetchHomepageImages() {
        FirestoreService.shared.fetchHomepageImages { [weak self] images in
            self?.homepageImages = images
            self?.onHomepageImagesFetched?()
        }
    }
    
    // MARK: - Packages Helpers
    func numberOfItems() -> Int {
        return packages.count
    }
    
    func package(at index: Int) -> DivePackage {
        return packages[index]
    }
    
    // MARK: - Infinite carousel helpers
    var homepageImagesRepeated: [String] {
        guard let data = homepageImages else { return [] }
        let urls = [data.imageUrl, data.imageUrlTwo, data.imageUrlThree, data.imageUrlFour]
        return Array(repeating: urls, count: 50).flatMap { $0 } // repeat more times
    }
    
    // MARK: - UI Configuration (from AppConstant)
    var logoImage: UIImage? {
        return UIImage(named: AppConstant.Home.logoImageName)
    }
    
    var notificationImage: UIImage? {
        return UIImage(named: AppConstant.Home.notificationImageName)
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
    
    var allDestinations: [DestinationItem] {
        return destinations.flatMap { $0.destinations }
    }
    
    var allEvents: [EventItem] {
        return events.flatMap { $0.events }
    }
    
}
