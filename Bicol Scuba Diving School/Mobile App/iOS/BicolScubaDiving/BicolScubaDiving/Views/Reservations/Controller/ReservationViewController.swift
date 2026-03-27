//
//  ReservationViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import FirebaseAuth

class ReservationViewController: UIViewController {
    
    // MARK: - Properties
    private let reservationView = ReservationView()
    private let reservationViewModel = ReservationViewModel()
    private let packageViewModel = PackageViewModel()
    private let bookingService = BookingService()
    private var bookings: [Booking] = []
    
    // Filtered bookings by tab
    private var activePackages: [DivePackage] = []
    private var completedPackages: [DivePackage] = []
    private var cancelledPackages: [DivePackage] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = reservationView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        
        packageViewModel.fetchPackages()
//        fetchBookings()
        
        reservationViewModel.fetchUserBookings()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBookingCancelled(_:)), name: .bookingCancelled, object: nil)

            
//            reservationViewModel.onBookingsUpdated = { [weak self] in
//                DispatchQueue.main.async {
//                    self?.reservationView.tableView.reloadData()
//                }
//            }
    }
    
    @objc private func handleBookingCancelled(_ notification: Notification) {
        guard let bookingId = notification.userInfo?["bookingId"] as? String else { return }

            // tell the view model to update itself
            reservationViewModel.updateLocalBookingStatus(bookingId: bookingId, to: "Cancelled")

            // UI will refresh via the view model callback (onBookingsUpdated).
            // If you don't already subscribe, ensure you reload after update:
            DispatchQueue.main.async {
                self.reservationView.tableView.reloadData()
            }
//        guard let bookingId = notification.userInfo?["bookingId"] as? String else { return }
//
//        // Move the booking to Cancelled tab
//        if let index = reservationViewModel.bookings.firstIndex(where: { $0.bookingId == bookingId }) {
//            var cancelledBooking = reservationViewModel.bookings[index]
//            cancelledBooking.status = "Cancelled"
//            
//            // ✅ Update the local list (triggers UI update)
//            reservationViewModel.bookings[index] = cancelledBooking
//            
//            DispatchQueue.main.async {
//                self.reservationView.tableView.reloadData()
//            }
//        }
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Setup
    private func setupBindings() {
        reservationView.configure(with: reservationViewModel)
        
        // When Firestore bookings update, reload the table view
        reservationViewModel.onBookingsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.reservationView.tableView.reloadData()
            }
        }
        
        // When user switches tabs, reload table view
        reservationViewModel.onTabChanged = { [weak self] _ in
            DispatchQueue.main.async {
                self?.reservationView.tableView.reloadData()
            }
        }
//        reservationView.configure(with: reservationViewModel)
//        
//        // Tab change (Active / Completed / Cancelled)
//        reservationViewModel.onTabChanged = { [weak self] _ in
//            self?.reservationView.tableView.reloadData()
//        }
//        
//        // Data loading state
//        packageViewModel.onLoadingStateChanged = { [weak self] isLoading in
//            if isLoading {
//                self?.reservationView.activityIndicator.startAnimating()
//            } else {
//                self?.reservationView.activityIndicator.stopAnimating()
//            }
//        }
//        
//        // When Firestore packages are loaded
//        packageViewModel.onDataUpdated = { [weak self] in
//            guard let self = self else { return }
//            
//            let allPackages = self.packageViewModel.packages
//            
//            // Active
//            if let last = allPackages.last {
//                self.activePackages = [last]
//            } else {
//                self.activePackages = []
//            }
//            
//            // Completed sample Data for demo
//            self.completedPackages = Array(allPackages.dropFirst().prefix(3))
//            
//            // Cancelled, Data from the list for now
//            self.cancelledPackages = Array(allPackages.prefix(1))
//            
//            self.reservationView.tableView.reloadData()
//        
//        }
    }
    
    func selectTab(index: Int) {
        reservationViewModel.selectTab(at: index)
        reservationView.tableView.reloadData()
    }

    
    private func setupTableView() {
        reservationView.tableView.dataSource = self
        reservationView.tableView.delegate = self
        reservationView.tableView.register(ReservationCell.self, forCellReuseIdentifier: "ReservationCell")
        reservationView.tableView.separatorStyle = .none
        reservationView.tableView.backgroundColor = .clear
    }
    
    // MARK: - Fetch Firestore Data
        private func fetchBookings() {
            guard let userId = Auth.auth().currentUser?.uid else { return }

            bookingService.fetchBookings(for: userId) { [weak self] fetchedBookings in
                self?.bookings = fetchedBookings
                DispatchQueue.main.async {
                    self?.reservationView.tableView.reloadData()
                }
            }
        }
    
    private var filteredBookings: [Booking] {
        switch reservationViewModel.selectedTabIndex {
        case 0:
            return reservationViewModel.bookings.filter {
                $0.status == "Active" ||
                $0.status == "Approved" ||
                $0.status == "Rescheduled"
            }
        case 1:
            return reservationViewModel.bookings.filter { $0.status == "Completed" }
        case 2:
            return reservationViewModel.bookings.filter { $0.status == "Cancelled" }
        default:
            return []
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
//extension ReservationViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch reservationViewModel.selectedTabIndex {
//        case 0: return activePackages.count
//        case 1: return completedPackages.count
//        case 2: return cancelledPackages.count
//        default: return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
//            return UITableViewCell()
//        }
//        
//        let package: DivePackage
//        switch reservationViewModel.selectedTabIndex {
//        case 0: package = activePackages[indexPath.row]
//        case 1: package = completedPackages[indexPath.row]
//        case 2: package = cancelledPackages[indexPath.row]
//        default: fatalError("Invalid tab index")
//        }
//        
//        cell.configure(with: package)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPackage: DivePackage
//        
//        // Identify which tab is active
//        switch reservationViewModel.selectedTabIndex {
//        case 0: selectedPackage = activePackages[indexPath.row]
//        case 1: selectedPackage = completedPackages[indexPath.row]
//        case 2: selectedPackage = cancelledPackages[indexPath.row]
//        default: return
//        }
//        
//        // ✅ Create a ViewModel for BookingDetails
//        let detailViewModel = ReservationDetailViewModel()
//        detailViewModel.setPackage(selectedPackage)
//        
//        // ✅ Create and push BookingDetailsViewController
//        let detailVC = BookingDetailsViewController()
//        detailVC.viewModel = detailViewModel
//        
//        navigationController?.pushViewController(detailVC, animated: true)
//    }

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ReservationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredBookings.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
                return UITableViewCell()
            }

            let booking = filteredBookings[indexPath.row]
            cell.configure(with: booking)
            return cell
        }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bookings.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
//            return UITableViewCell()
//        }
//
//        let booking = bookings[indexPath.row]
//        cell.configure(with: booking)
//        
//        
//        //  Configure ReservationCell using booking data
////        cell.packageTitleLabel.text = booking.packageName
////        cell.priceLabel.text = "₱\(booking.price)"
////        cell.statusLabel.text = booking.status
//        return cell
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let booking = filteredBookings[indexPath.row]
                let detailVC = BookingDetailsViewController(booking: booking)
                navigationController?.pushViewController(detailVC, animated: true)
//        let booking = bookings[indexPath.row]
//        let detailVC = BookingDetailsViewController(booking: booking)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    // Custom card size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
