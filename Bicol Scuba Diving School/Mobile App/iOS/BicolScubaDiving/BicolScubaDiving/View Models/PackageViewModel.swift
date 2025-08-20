//
//  PackageViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/20/25.
//

final class PackageViewModel {
    
    private(set) var packages: [DivePackage] = []
    var onDataUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    func fetchPackages() {
        onLoadingStateChanged?(true)
        FirestoreService.shared.fetchDivePackages { [weak self] packages in
            self?.packages = packages
            self?.onLoadingStateChanged?(false)
            self?.onDataUpdated?()
        }
    }
    
    func numberOfItems() -> Int {
        return packages.count
    }
    
    func package(at index: Int) -> DivePackage {
        return packages[index]
    }
}
