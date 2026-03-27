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
    
    var id: String {
        return package.id
    }
    
    var title: String {
        return package.title
    }
    
    var description: String {
        return package.description
    }
    
    var requirements: [String] {
        return package.requirements
    }

    var imageUrl: String {
        return package.imageUrl
    }
    
    var price: String {
        return "\(package.price)"
    }
    
    var totalSlot: Int { package.totalSlot }
    var bookedSlot: Int { package.bookedSlot }

    
    var isSlotFull: Bool {
        return package.bookedSlot >= package.totalSlot
    }

    
    var slotAvailable: String {
        return "\(package.bookedSlot) / \(package.totalSlot)"
//        let available = package.totalSlot - package.bookedSlot
//        return "\(available) / \(package.totalSlot)"
    }
    var isActive: Bool { package.isActive }
    var disabledReason: String { package.disabledReason }

}

extension PackageDetailViewModel {
    func toDivePackage() -> DivePackage {
        return DivePackage(
            id: self.id,
                        title: self.title,
                        description: self.description,
                        imageUrl: self.imageUrl,
                        price: self.price,               // price is String in your DivePackage
            isActive: self.isActive,//true,                  // choose appropriate default
                        totalSlot: package.totalSlot,    // preserve original values if available
                        bookedSlot: package.bookedSlot,
                        requirements: self.requirements,
            disabledReason: self.disabledReason
        )
    }
}
