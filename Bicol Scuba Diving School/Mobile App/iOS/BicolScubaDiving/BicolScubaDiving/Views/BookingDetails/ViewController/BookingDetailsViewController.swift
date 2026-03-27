//
//  BookingDetailsViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/24/25.
//

import Foundation
import UIKit

class BookingDetailsViewController: UIViewController {
    
    private let bookingDetailsView = BookingDetailsView()
    var viewModel = ReservationDetailViewModel()
    
    private let booking: Booking
    
    init(booking: Booking) {
            self.booking = booking
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func loadView() {
        view = bookingDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        populateBookingDetails()
        
//        bindViewModel()
//        //  Load your static details
//            viewModel.loadReservationDetails()
        
        bookingDetailsView.onBackTapped = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
        
        bookingDetailsView.onCancelTapped = { [weak self] in
                self?.showCancelConfirmation()
            }
    }
    
    private func showCancelConfirmation() {
        let alert = UIAlertController(
            title: "Cancel Booking",
            message: "Are you sure you want to cancel this booking?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.cancelBooking()
        }))
        
        present(alert, animated: true)
    }
    
    private func cancelBooking() {
        let bookingService = BookingService()
        
        bookingService.updateBookingStatus(bookingId: booking.bookingId, newStatus: "Cancelled") { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Failed to cancel booking: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to cancel booking. Please try again.")
                return
            }
            
            print("✅ Booking cancelled successfully.")
            self.showAlert(title: "Booking Cancelled", message: "Your booking has been cancelled.") {
                // ✅ Notify ReservationViewController to refresh
                NotificationCenter.default.post(name: .bookingCancelled, object: nil, userInfo: ["bookingId": self.booking.bookingId])
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion?() }))
        present(alert, animated: true)
    }


    
    private func populateBookingDetails() {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
        let shortBookingId = String(booking.bookingId.prefix(8))
        
        

            bookingDetailsView.packageNameLabel.text = booking.packageName
            bookingDetailsView.statusLabel.text = booking.status
            bookingDetailsView.bookingNumberValueLabel.text = shortBookingId
            bookingDetailsView.dateValueLabel.text = formatter.string(from: booking.date)
            bookingDetailsView.priceValueLabel.text = "₱\(booking.price)"
        bookingDetailsView.rescheduleReasonValueLabel.text = booking.rescheduleReason ?? "—"
        bookingDetailsView.rescheduleDateValueLabel.text = booking.rescheduleDate ?? "—"


        
        bookingDetailsView.instructorValueLabel.text = booking.instructor ?? "Not Assigned"
        }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self,
                  let detail = self.viewModel.reservationDetail else { return }
            
            DispatchQueue.main.async {
                self.bookingDetailsView.packageNameLabel.text = detail.packageName
                self.bookingDetailsView.statusLabel.text = detail.status
                self.bookingDetailsView.bookingNumberValueLabel.text = detail.bookingNumber
                self.bookingDetailsView.dateValueLabel.text = detail.date
                self.bookingDetailsView.priceValueLabel.text = detail.price
                
            }
        }
    }
}
