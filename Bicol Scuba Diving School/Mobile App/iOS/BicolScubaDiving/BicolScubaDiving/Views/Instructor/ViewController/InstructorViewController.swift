//
//  InstructorViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/20/25.
//
import UIKit
import FirebaseAuth

class InstructorViewController : UIViewController {
    
    private let instructorView = InstructorView()
        private let dashboardViewModel = InstructorDashboardViewModel()
        
        override func loadView() {
            view = instructorView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            instructorView.viewModel = InstructorViewModel()
            
            // ✅ Get currently logged-in instructor UID
            if let instructorId = Auth.auth().currentUser?.uid {
                dashboardViewModel.fetchAssignedBookings(for: instructorId)
            } else {
                print("❌ No logged-in instructor UID found.")
            }

            // ✅ Handle booking updates
            dashboardViewModel.onBookingsUpdated = { [weak self] bookings in
                print("DEBUG: \(bookings.count) bookings received.")
                
                guard let firstBooking = bookings.first else {
                    print("No bookings found for instructor.")
                    return
                }
                
                let participants = firstBooking.companions.map { $0.fullName }
                
                let bookingVM = InstructorBookingViewModel(
                    bookingId: firstBooking.bookingId,
                    packageName: firstBooking.packageName,
                    reservationDate: firstBooking.reservationDate,
                    participants: participants,
                    instructorName: firstBooking.instructor
                )
                
                DispatchQueue.main.async {
                    self?.instructorView.bookingCardView.viewModel = bookingVM
                }
            }
        }
    }
    
//    private let instructorView = InstructorView()
//        private let dashboardViewModel = InstructorDashboardViewModel()
//        
//        override func loadView() {
//            view = instructorView
//        }
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            
//            instructorView.viewModel = InstructorViewModel()
//            
//            // 🔹 Example: Use the instructor's name (you can fetch it from the logged-in user)
//            //let instructorName = "Gregor Cruz"
//            if let instructorId = Auth.auth().currentUser?.uid {
//                dashboardViewModel.fetchAssignedBookings(for: instructorId)
//            } else {
//                print("❌ No logged-in instructor UID found.")
//            }
//
//            
//            dashboardViewModel.onBookingsUpdated = { [weak self] bookings in
//                
//                print("DEBUG: \(bookings.count) bookings received.")
//                
//                guard let firstBooking = bookings.first else {
//                    
//                    print("No bookings found for instructor.")
//                    
//                    return }
//                
//                let participants = firstBooking.companions.map { $0.fullName }
//                let bookingVM = InstructorBookingViewModel(
//                    bookingId: firstBooking.bookingId,
//                    packageName: firstBooking.packageName,
//                    reservationDate: firstBooking.reservationDate,
//                    participants: participants
//                )
//                
//                DispatchQueue.main.async {
//                    self?.instructorView.bookingCardView.viewModel = bookingVM
//                }
//            }
//            
//            dashboardViewModel.fetchAssignedBookings(for: instructorName)
//        }
//    }
    
//    private let instructorView = InstructorView()
//    private let viewModel = InstructorViewModel()
//    
//    override func loadView() {
//        view = instructorView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        instructorView.viewModel = viewModel
//        
//    }
//    
//}
