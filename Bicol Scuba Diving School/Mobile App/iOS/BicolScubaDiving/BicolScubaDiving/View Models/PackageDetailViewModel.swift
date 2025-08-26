//
//  PackageDetailViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import Foundation

final class PackageDetailViewModel {
    
    private let package: DivePackage
    
    init(package: DivePackage) {
        self.package = package
    }
    
    var title: String {
        return package.title
    }
    
    var description: String {
        return package.description
    }
    
    var imageUrl: String {
        return package.imageUrl
    }
    
    var price: String {
        return "\(package.price)"
    }
    
    var slotAvailable: String {
        let available = package.totalSlot - package.bookedSlot
        return "\(available) / \(package.totalSlot)"
    }
}
