//
//  PaymentConfirmationViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/30/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PaymentConfirmationViewController: UIViewController {
    
    private let package: PackageDetailViewModel
        private let bookingService = BookingService()
    private let viewModel: BookingViewModel
        
        init(package: PackageDetailViewModel, viewModel: BookingViewModel) {
            self.package = package
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            let confirmationView = PaymentConfirmationView()
                view.addSubview(confirmationView)
                confirmationView.frame = view.bounds
                
                // Handle home button tap
                confirmationView.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
            
            // Save booking automatically after payment
            saveBookingAfterPayment()
        }
        
        private func saveBookingAfterPayment() {
            guard let user = Auth.auth().currentUser else {
                print("❌ No authenticated user found.")
                return }
            
            let companionsData = viewModel.companions.map {
                Companion(
                    fullName: $0.fullName.isEmpty ? "Unknown Companion" : $0.fullName,
                                medicalCertificateUrl: $0.medicalCertificateUrl ?? ""
                )
            }
            
            print("🧩 Companions before saving: \(companionsData.map { $0.dictionary })")
            
            // ✅ Collect data from the view model
            //let companions = viewModel.companions
            let userMedicalCertificateUrl = viewModel.mainMedicalCertificateUrl ?? ""
            let reservationDate = viewModel.reservationDate ?? DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none) //DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)

                    
            // ✅ Parse price safely
            let priceValue = Double(package.price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0.0
            
//            let userRef = Firestore.firestore().collection("users").document(user.uid) TRY THIS FOR FETCHING USER PHONE NUMBER
//            userRef.getDocument { snapshot, error in
//                let phoneNumber = snapshot?.data()?["phoneNumber"] as? String ?? "N/A"
            
            
            let phoneNumber = (viewModel.phoneNumber?.isEmpty == false)
                ? viewModel.phoneNumber!
                : (user.phoneNumber ?? "N/A")

            
            // ✅ Call BookingService.createBooking()
                    bookingService.createBooking(
                        from: package.toDivePackage(), // Convert your view model to DivePackage if needed
                        userId: user.uid,
                        userName: user.displayName ?? "Unknown User",
                        email: user.email ?? "",
                        phoneNumber: phoneNumber, //viewModel.phoneNumber ?? user.phoneNumber ?? "N/A",
                        paymentAmount: priceValue,
                        paymentMethod: "GCash",
                        userMedicalCertificateUrl: userMedicalCertificateUrl,
                        companions: companionsData, //companions,
                        reservationDate: reservationDate,
                        status: "Active"
                    ) { error in
                        if let error = error {
                            print("❌ Failed to save booking: \(error.localizedDescription)")
                        } else {
                            print("✅ Booking successfully created in Firestore with certificates & companions.")
                            print("✅ Saving phone number: \(self.viewModel.phoneNumber ?? "nil")")
                            DispatchQueue.main.async {
                                self.navigateToReservation()
                            }
                        }
                    }
            
//            let booking = Booking(
//                    userId: user.uid,
//                    userName: user.displayName ?? "Unknown User",
//                    email: user.email ?? "",
//                    phoneNumber: "N/A",
//                    packageName: package.title,
//                    imageUrl: package.imageUrl,
//                    price: Double(package.price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0.0,
//                    paymentAmount: Double(package.price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0.0,
//                    paymentMethod: "GCash",
//                    userMedicalCertificateUrl: "", // replace once you upload the user's medical cert
//                    companions: [], // populate from BookingViewModel if available
//                    reservationDate: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
//                    status: "Approved"
//                )
//
//                bookingService.saveBooking(booking) { error in
//                    if let error = error {
//                        print("❌ Save failed: \(error.localizedDescription)")
//                    } else {
//                        print("✅ Booking successfully created in Firestore.")
//                    }
//                }
            
//            // Convert your PackageDetailViewModel → DivePackage
//            let divePackage = DivePackage(
//                id: package.id,
//                title: package.title,
//                description: package.description,
//                imageUrl: package.imageUrl,
//                price: package.price,
//                isActive: true,
//                totalSlot: 0,
//                bookedSlot: 0,
//                requirements: []
//            )
//            
//            // Save to Firestore
//            bookingService.createBooking(from: divePackage, userId: userId, status: "Active") { [weak self] error in
//                if let error = error {
//                    print("❌ Failed to save booking:", error.localizedDescription)
//                    return
//                }
//                print("✅ Booking created successfully in Firestore")
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self?.navigateToReservation()
//                }
//            }
        }
        
        private func navigateToReservation() {
            // Navigate back to ReservationScreen and show Active tab
            
            // Find the main tab bar controller
                if let tabBarController = self.view.window?.rootViewController as? MainTabBarController {
                    // Switch to Reservation tab (index 2)
                    tabBarController.selectedIndex = 2
                    
                    // Optionally, if ReservationVC is inside a UINavigationController:
                    if let navController = tabBarController.viewControllers?[2] as? UINavigationController,
                       let reservationVC = navController.viewControllers.first as? ReservationViewController {
                        
                        // Reset to the Active tab (optional)
                        reservationVC.selectTab(index: 0)
                    }
                } else {
                    print("⚠️ Could not find MainTabBarController")
                }
            
            
//            DispatchQueue.main.async {
//                let reservationVC = ReservationViewController()
//                reservationVC.modalPresentationStyle = .fullScreen
//                self.navigationController?.setViewControllers([reservationVC], animated: true)
//                    }
            
//            let reservationVC = ReservationViewController()
//            reservationVC.modalPresentationStyle = .fullScreen
//            navigationController?.setViewControllers([reservationVC], animated: true)
        }
    
    @objc private func homeButtonTapped() {
        // Find MainTabBarController
        if let tabBarController = self.view.window?.rootViewController as? MainTabBarController {
            tabBarController.selectedIndex = 2 // Reservation tab

            // If inside a navigation controller
            if let navController = tabBarController.viewControllers?[2] as? UINavigationController,
               let reservationVC = navController.viewControllers.first as? ReservationViewController {
                reservationVC.selectTab(index: 0) // Active bookings tab
                navController.popToRootViewController(animated: false)
            }
        } else {
            print("⚠️ Could not find MainTabBarController")
        }
    }

    
    
    
//    private let confirmationView = PaymentConfirmationView()
//    private let bookingService = BookingService()
//    //private let selectedPackage: DivePackage  // ✅ store the selected package
//    
//    private let selectedPackage: PackageDetailViewModel  // ✅ Now receiving this from BookingViewController
//    
//    // MARK: - Init
//    init(package: PackageDetailViewModel) {
//        self.selectedPackage = package
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        view.addSubview(confirmationView)
//        confirmationView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        confirmationView.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
//    }
//    
//    @objc private func homeButtonTapped() {
//        navigateToHomeScreen()
//    }
//    
//    private func saveBookingAfterPayment() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        
//        let bookingId = UUID().uuidString
//        let booking = Booking(
//            id: bookingId,
//            userId: userId,
//            packageName: selectedPackage.title,
//            price: selectedPackage.price,
//            status: "Pending",
//            date: Date()
//        )
//        
//        bookingService.saveBooking(booking) { [weak self] error in
//            if let error = error {
//                print("❌ Failed to save booking:", error)
//            } else {
//                print("✅ Booking saved successfully.")
//                self?.navigateToHomeScreen()
//            }
//        }
//        //            guard let userId = Auth.auth().currentUser?.uid else { return }
//        //
//        //            let bookingId = UUID().uuidString
//        //            let booking = Booking(
//        //                id: bookingId,
//        //                userId: userId,
//        //                packageName: selectedPackage.title,       // ✅ fetch actual package name
//        //                price: selectedPackage.price,             // ✅ fetch actual package price
//        //                status: "Pending",
//        //                date: Date()
//        //            )
//        //
//        //            bookingService.saveBooking(booking) { [weak self] error in
//        //                if let error = error {
//        //                    print("❌ Failed to save booking:", error)
//        //                } else {
//        //                    print("✅ Booking saved successfully.")
//        //                    self?.navigateToReservationScreen()
//        //                }
//        //            }
//    }
//    
//    private func navigateToReservationScreen() {
//        DispatchQueue.main.async {
//            let reservationVC = ReservationViewController()
//            self.navigationController?.setViewControllers([reservationVC], animated: true)
//        }
//    }
//    private func navigateToHomeScreen() {
//        DispatchQueue.main.async {
//            let homeVC = HomeViewController()
//            self.navigationController?.setViewControllers([homeVC], animated: true)
//        }
//    }
    
}

