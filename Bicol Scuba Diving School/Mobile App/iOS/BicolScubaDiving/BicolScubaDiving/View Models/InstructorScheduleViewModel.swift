//
//  InstructorScheduleViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/16/25.
//

import UIKit
import FirebaseAuth

class InstructorScheduleViewModel {
    
    // MARK: - Properties
    let logoImage: UIImage?
    let titleText: String
    let tabTitles: [String]
    private(set) var selectedTabIndex: Int = 0
    
    var onTabChanged: ((Int) -> Void)?
    
    // MARK: - Init
    init() {
        self.logoImage = UIImage(named: AppConstant.Instructor.logo)
        self.titleText = AppConstant.Instructor.bookingScheduleTitle
        self.tabTitles = ["Active", "Completed"]
    }
    
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabTitles.count else { return }
        selectedTabIndex = index
        onTabChanged?(index)
    }
}

extension InstructorScheduleViewModel {
    func fetchInstructorBookings(completion: @escaping ([Booking]) -> Void) {
        guard let instructorId = Auth.auth().currentUser?.uid else {
            print("❌ No instructor logged in.")
            completion([])
            return
        }
        
        let bookingService = BookingService()
        bookingService.fetchBookingsForInstructor(instructorId) { bookings in
            completion(bookings)
        }
    }
}
