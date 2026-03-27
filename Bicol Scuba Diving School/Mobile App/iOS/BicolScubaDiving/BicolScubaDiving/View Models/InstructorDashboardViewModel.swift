//
//  InstructorDashboardViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/29/25.
//

import Foundation

class InstructorDashboardViewModel {
    private let bookingService = BookingService()
    
    var assignedBookings: [Booking] = [] {
        didSet {
            onBookingsUpdated?(assignedBookings)
        }
    }
    
    var onBookingsUpdated: (([Booking]) -> Void)?
    
    func fetchAssignedBookings(for instructorName: String) {
        bookingService.fetchBookingsForInstructor(instructorName) { [weak self] bookings in
            self?.assignedBookings = bookings
        }
    }
}
