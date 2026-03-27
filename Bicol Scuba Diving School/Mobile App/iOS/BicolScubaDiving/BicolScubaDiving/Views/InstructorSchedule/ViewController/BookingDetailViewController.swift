//
//  BookingDetailViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/16/25.
//

import Foundation
import UIKit
import FirebaseFirestore

class BookingDetailViewController: UIViewController {
    
    private let detailView: InstructorBookingDetailView
        private let viewModel: BookingDetailViewModel
        private let db = Firestore.firestore()

        init(viewModel: BookingDetailViewModel) {
            self.viewModel = viewModel
            self.detailView = InstructorBookingDetailView()
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func loadView() {
            self.view = detailView
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            detailView.configure(with: viewModel)
            navigationController?.setNavigationBarHidden(true, animated: false)
            
            detailView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            // 👇 Add the Completed button action
            detailView.onCompletedTapped = { [weak self] in
                self?.showCompletionAlert()
            }
        }

        @objc private func backButtonTapped() {
            navigationController?.popViewController(animated: true)
        }
        
        // MARK: - 🔹 Confirmation and Firestore Update
        private func showCompletionAlert() {
            let alert = UIAlertController(
                title: "Mark as Completed",
                message: "Are you sure this booking is completed?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
                self?.markBookingAsCompleted()
            }))

            present(alert, animated: true)
        }

        private func markBookingAsCompleted() {
            let bookingId = viewModel.bookingId

                db.collection("bookings").document(bookingId).updateData([
                    "status": "Completed"
                ]) { [weak self] error in
                    guard let self = self else { return }

                    if let error = error {
                        print("❌ Failed to update booking: \(error.localizedDescription)")
                        return
                    }

                    print("✅ Booking \(bookingId) marked as Completed.")

                    // 🔹 Post a notification so InstructorScheduleViewController knows
                    NotificationCenter.default.post(
                        name: Notification.Name("BookingCompleted"),
                        object: nil,
                        userInfo: ["bookingId": bookingId]
                    )

                    // 🔹 Show success popup
                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "This booking has been marked as completed.",
                        preferredStyle: .alert
                    )
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(successAlert, animated: true)
                }
//            let bookingId = viewModel.bookingId
//            
//            db.collection("bookings").document(bookingId).updateData([
//                "status": "Completed"
//            ]) { error in
//                if let error = error {
//                    print("❌ Failed to update booking: \(error.localizedDescription)")
//                    return
//                }
//                
//                print("✅ Booking \(bookingId) marked as Completed.")
//                
//                // Optional: Show success popup
//                let successAlert = UIAlertController(
//                    title: "Success",
//                    message: "This booking has been marked as completed.",
//                    preferredStyle: .alert
//                )
//                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                    self.navigationController?.popViewController(animated: true)
//                }))
//                self.present(successAlert, animated: true)
//            }
        }
    }
    
    
    
//    // MARK: - Properties
//    private let detailView: InstructorBookingDetailView
//        private let viewModel: BookingDetailViewModel
//        
//        // MARK: - Init
//        init(viewModel: BookingDetailViewModel) {
//            self.viewModel = viewModel
//            self.detailView = InstructorBookingDetailView()
//            super.init(nibName: nil, bundle: nil)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        // MARK: - Lifecycle
//        override func loadView() {
//            self.view = detailView
//        }
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            detailView.configure(with: viewModel)
//            
//            // Hide the system navigation bar so only your custom header is visible
//            navigationController?.setNavigationBarHidden(true, animated: false)
//            
//            // Add tap action for your back-logo image
//            detailView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        }
//        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            // Re-show navigation bar when leaving detail screen
//            navigationController?.setNavigationBarHidden(false, animated: false)
//        }
//        
//        // MARK: - Actions
//        @objc private func backButtonTapped() {
//            navigationController?.popViewController(animated: true)
//        }
//}
