//
//  InstructorScheduleViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/15/25.
//

import UIKit
import Foundation

class InstructorScheduleViewController: UIViewController {
    
    // MARK: - Properties
        private let instructorScheduleView = InstructorScheduleView()
        private let viewModel = InstructorScheduleViewModel()
        //private let packageViewModel = PackageViewModel() // 👈 Add this for fetching
        
        // Data arrays
//        private var activePackages: [DivePackage] = []
//        private var completedPackages: [DivePackage] = []
    
    // 🔹 Replace DivePackage arrays with Booking arrays
        private var activeBookings: [Booking] = []
        private var completedBookings: [Booking] = []
        
        // MARK: - Lifecycle
        override func loadView() {
            self.view = instructorScheduleView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            instructorScheduleView.configure(with: viewModel)
            setupTableView()
            setupBindings()
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleBookingCompleted(_:)),
                name: Notification.Name("BookingCompleted"),
                object: nil
            )

            
            // Start fetching real data
            //packageViewModel.fetchPackages()
            
            // 🔹 Fetch instructor bookings
                    viewModel.fetchInstructorBookings { [weak self] bookings in
                        guard let self = self else { return }
                        
                        // Example filtering logic:
                        self.activeBookings = bookings.filter {
                            $0.status == "Approved" ||
                            $0.status == "Rescheduled"
                        }
                        self.completedBookings = bookings.filter { $0.status == "Completed" }
                        
                        DispatchQueue.main.async {
                            self.instructorScheduleView.tableView.reloadData()
                        }
                    }
            
        }
        
        // MARK: - Setup
        private func setupTableView() {
            instructorScheduleView.tableView.dataSource = self
            instructorScheduleView.tableView.delegate = self
            instructorScheduleView.tableView.register(InstructorScheduleCell.self, forCellReuseIdentifier: "InstructorScheduleCell")
            instructorScheduleView.tableView.backgroundColor = .clear
        }
        
        private func setupBindings() {
            // Handle tab change
            viewModel.onTabChanged = { [weak self] _ in
                self?.instructorScheduleView.tableView.reloadData()
            }
            
            // Handle data updates from Firestore / API
//            packageViewModel.onDataUpdated = { [weak self] in
//                guard let self = self else { return }
//                
//                let allPackages = self.packageViewModel.packages
//                
//                // Filter normally
//                        let active = allPackages.filter { $0.isActive }
//                        let completed = allPackages.filter { !$0.isActive }
//                        
//                        // Limit to only 2 bookings in Active tab
//                        self.activePackages = Array(active.prefix(2))
//                        self.completedPackages = completed
//                
//                DispatchQueue.main.async {
//                    self.instructorScheduleView.tableView.reloadData()
//                }
//            }
        }
    
    @objc private func handleBookingCompleted(_ notification: Notification) {
        guard let bookingId = notification.userInfo?["bookingId"] as? String else { return }

        // Find the booking in active list
        if let index = activeBookings.firstIndex(where: { $0.bookingId == bookingId }) {
            var completedBooking = activeBookings[index]
            completedBooking.status = "Completed"

            // Remove from active and add to completed
            activeBookings.remove(at: index)
            completedBookings.insert(completedBooking, at: 0)

            print("✅ Booking moved to Completed tab.")
        }

        // Refresh UI if current tab is Active or Completed
        DispatchQueue.main.async {
            self.instructorScheduleView.tableView.reloadData()
        }
    }
    
}


extension InstructorScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.selectedTabIndex {
                case 0: return activeBookings.count
                case 1: return completedBookings.count
                default: return 0
                }
//        switch viewModel.selectedTabIndex {
//        case 0: return activePackages.count
//        case 1: return completedPackages.count
//        default: return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstructorScheduleCell", for: indexPath) as? InstructorScheduleCell else {
            return UITableViewCell()
        }
        
        let booking: Booking
                switch viewModel.selectedTabIndex {
                case 0: booking = activeBookings[indexPath.row]
                case 1: booking = completedBookings[indexPath.row]
                default: fatalError("Invalid tab index")
                }
        
//        let package: DivePackage
//        switch viewModel.selectedTabIndex {
//        case 0: package = activePackages[indexPath.row]
//        case 1: package = completedPackages[indexPath.row]
//        default: fatalError("Invalid tab index")
//        }
        
        // Each booking gets a formatted booking number (001, 002, etc.)
       // let bookingNumber = booking.bookingId//String(format: "Booking #%03d", indexPath.row + 1)
//        cell.configure(with: package, bookingNumber: bookingNumber)
        
        //let bookings = activeBookings[indexPath.row] // or completedBookings depending on the tab

        // 🔹 Take first 8 characters of the Firestore ID and make uppercase
        //let shortId = String(bookings.bookingId.prefix(8)).uppercased()
        
        // 🔹 Take first 8 characters of the Firestore bookingId
            let shortId = String(booking.bookingId.prefix(8)).uppercased()
            
            // 🔹 Pass formatted label text directly to your cell
            let formattedBookingId = "Booking: \(shortId)"
        
        cell.configure(
                    title: booking.packageName,
                    imageUrl: booking.imageUrl,
                    bookingNumber: formattedBookingId
                )
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // ✅ Handle Cell Selection — navigate to Booking Detail screen
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let booking: Booking
            switch viewModel.selectedTabIndex {
            case 0: booking = activeBookings[indexPath.row]
            case 1: booking = completedBookings[indexPath.row]
            default: return
            }

//            let package: DivePackage
//            switch viewModel.selectedTabIndex {
//            case 0: package = activePackages[indexPath.row]
//            case 1: package = completedPackages[indexPath.row]
//            default: return
//            }
            
            // Generate booking number dynamically
            //let shortId = activeBookings[indexPath.row]
            
            //let bookingNumber =
            //booking.bookingId //String(format: "#%03d", indexPath.row + 1)
            
            let bookings = activeBookings[indexPath.row] // or completedBookings depending on the tab

            // 🔹 Take first 8 characters of the Firestore ID and make uppercase
            let shortId = String(bookings.bookingId.prefix(8)).uppercased()
            
            
            // Create ViewModel for the detail screen
            
            let detailVM = BookingDetailViewModel(
                bookingId: booking.bookingId,
                bookingNumber: shortId,
                packageName: booking.packageName,
                name: booking.userName,
                dateTime: booking.reservationDate,
                email: booking.email,
                phoneNumber: booking.phoneNumber,
                participants: booking.companions.map { $0.fullName }
            )

            
//            let detailVM = BookingDetailViewModel(
//                booking: booking, bookingNumber: shortId
//                
////                bookingNumber: bookingNumber,
////                packageName: package.title
//            )
            
            // Initialize and push detail screen
            let detailVC = BookingDetailViewController(viewModel: detailVM)
            detailVC.hidesBottomBarWhenPushed = true
            
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(detailVC, animated: true)
        }
}

