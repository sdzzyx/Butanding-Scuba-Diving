//
//  ReservationDetailViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/24/25.
//

import Foundation
import UIKit

class ReservationDetailViewModel {
    
    // MARK: - Properties
    private(set) var reservationDetail: ReservationDetailModel?
    
    
    // MARK: - Callbacks for Data Binding
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Load Data
    func loadReservationDetails() {
        // This could later come from API, database, or Firebase
        let detail = ReservationDetailModel(
            packageName: AppConstant.BookingDetails.packageName,
            status: AppConstant.BookingDetails.pendingTitle,
            bookingNumber: AppConstant.BookingDetails.bookingPlaceholder,
            date: AppConstant.BookingDetails.datePlaceholder,
            price: AppConstant.BookingDetails.pricePlaceholder,
            imageUrl: ""
        )
        
        self.reservationDetail = detail
        onDataUpdated?()
    }
    
    // MARK: - Set from DivePackage
    func setPackage(_ package: DivePackage) {
        // Map DivePackage → ReservationDetailModel
        self.reservationDetail = ReservationDetailModel(
            packageName: package.title,
            status: AppConstant.BookingDetails.pendingTitle, // You can replace with actual status field
            bookingNumber: AppConstant.BookingDetails.bookingPlaceholder, // Replace with booking ID if available
            date: AppConstant.BookingDetails.datePlaceholder,
            price: "₱\(package.price)",
            imageUrl: package.imageUrl
        )
        onDataUpdated?()
    }
    
}
