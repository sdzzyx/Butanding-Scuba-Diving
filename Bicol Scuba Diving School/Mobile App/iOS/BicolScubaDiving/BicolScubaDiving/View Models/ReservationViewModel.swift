//
//  ReservationViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ReservationViewModel {
    
    private let db = Firestore.firestore()
    private(set) var bookings: [Booking] = []
    
    var onBookingsUpdated: (() -> Void)?
    
    // MARK: - Properties
    let logoImage: UIImage?
    let titleText: String
    let tabTitles: [String]
    private(set) var selectedTabIndex: Int = 0
    
    var onTabChanged: ((Int) -> Void)?
    
    // MARK: - Init
    init() {
        self.logoImage = UIImage(named: AppConstant.Reservation.logo)
        self.titleText = AppConstant.Reservation.reservationTitle
        self.tabTitles = [
            AppConstant.Reservation.Tabs.active,
            AppConstant.Reservation.Tabs.completed,
            AppConstant.Reservation.Tabs.cancelled
        ]
        self.selectedTabIndex = 0
    }
    
    func selectTab(at index: Int) {
            guard index >= 0 && index < tabTitles.count else { return }
            selectedTabIndex = index
            onTabChanged?(index)
        }
        
        // MARK: - Fetch Bookings from Firestore
        func fetchUserBookings() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            db.collection("bookings")
                .whereField("userId", isEqualTo: userId)
                .addSnapshotListener { [weak self] snapshot, error in
                    if let error = error {
                        print("❌ Error fetching bookings: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    self?.bookings = documents.compactMap { Booking(document: $0) }

                    print("✅ Loaded \(self?.bookings.count ?? 0) bookings for user: \(userId)")
                    self?.onBookingsUpdated?()
                }

            
//            db.collection("bookings")
//                .whereField("userId", isEqualTo: userId)
//                .addSnapshotListener { [weak self] snapshot, error in
//                    if let error = error {
//                        print("❌ Error fetching bookings: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    guard let documents = snapshot?.documents else { return }
//                    self?.bookings = documents.compactMap { doc in
//                        try? doc.data(as: Booking.self)
//                    }
//                    
//                    print("✅ Fetched \(self?.bookings.count ?? 0) bookings")
//                    self?.onBookingsUpdated?()
//                }
        }
    
    
    // call this to replace the entire list (e.g. after fetching from Firestore)
        func setBookings(_ new: [Booking]) {
            self.bookings = new
            onBookingsUpdated?()
        }

        // update single booking status locally and notify UI
        func updateLocalBookingStatus(bookingId: String, to newStatus: String) {
            guard let idx = bookings.firstIndex(where: { $0.bookingId == bookingId }) else { return }
            let updated = bookings[idx].with(status: newStatus)
            bookings[idx] = updated
            onBookingsUpdated?()
        }
    
}
