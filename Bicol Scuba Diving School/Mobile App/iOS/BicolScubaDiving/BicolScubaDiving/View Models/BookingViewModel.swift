//
//  BookingViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import Foundation
import UIKit

class BookingViewModel {
    
    var bookings: [String] = []
    
    var isLoading: Bool = false
    
    var phoneNumber: String?
    
    var reservationDate: String?

    
    // Main User
    var mainUserCertificate: UIImage?
    //var onMainCertificateUpdated: ((UIImage) -> Void)?
    
    var mainMedicalCertificateUrl: String?
        
    var onMainCertificateUpdated: ((String) -> Void)? // Now passes URL instead of UIImage
    
    // Companions
    var companions: [Companion] = [] {
        didSet {
            onCompanionsUpdated?(companions)
        }
    }
    
    var onNumberOfCompanionsChanged: ((Int) -> Void)?
    var onCompanionsUpdated: (([Companion]) -> Void)?
    
    var numberOfCompanions: Int = 0 {
        didSet {
            if numberOfCompanions > companions.count {
                for _ in companions.count..<numberOfCompanions {
                    companions.append(Companion())
                }
            } else {
                companions = Array(companions.prefix(numberOfCompanions))
            }
            onNumberOfCompanionsChanged?(numberOfCompanions)
        }
    }
    
    func updateCompanionCount(_ count: Int) {
        if companions.count < count {
            // Add missing companions
            let difference = count - companions.count
            companions.append(contentsOf: Array(repeating: Companion(), count: difference))
        } else if companions.count > count {
            // Remove extra companions
            companions.removeLast(companions.count - count)
        }

        onCompanionsUpdated?(companions)
    }

    
    func updateMainCertificate(url: String) {
        self.mainMedicalCertificateUrl = url
        onMainCertificateUpdated?(url)
        print("✅ Main certificate uploaded URL: \(url)")
    }
    
    func updateCertificate(for index: Int, url: String) {
        guard index > 0, index <= companions.count else { return }
        companions[index - 1].medicalCertificateUrl = url
        onCompanionsUpdated?(companions)
        print("✅ Companion \(index) certificate uploaded URL: \(url)")
    }
    
    func updateFullName(for index: Int, name: String) {
        guard index > 0, index <= companions.count else { return }
        companions[index - 1].fullName = name
        onCompanionsUpdated?(companions)
        print("✏️ Updated companion \(index) full name: \(name)")
    }
}
