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
    
    // Main User
    var mainUserCertificate: UIImage?
    var onMainCertificateUpdated: ((UIImage) -> Void)?
    
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
    
    func updateMainCertificate(image: UIImage) {
        self.mainUserCertificate = image
        onMainCertificateUpdated?(image)
    }
    
    func updateCertificate(for index: Int, image: UIImage) {
        guard index > 0, index <= companions.count else { return }
        companions[index - 1].medicalCertificate = image
        onCompanionsUpdated?(companions)
    }
    
    func updateFullName(for index: Int, name: String) {
        guard index > 0, index <= companions.count else { return }
        companions[index - 1].fullName = name
        onCompanionsUpdated?(companions)
    }
}
