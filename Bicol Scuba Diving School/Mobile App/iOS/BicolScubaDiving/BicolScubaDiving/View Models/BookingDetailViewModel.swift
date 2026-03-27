//
//  BookingDetailViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/16/25.
//

import Foundation
import UIKit

class BookingDetailViewModel {
    
    // MARK: - Properties
    let bookingId: String
    let bookingNumber: String
    let packageName: String
    let name: String
    let dateTime: String
    let email: String
    let phoneNumber: String
    let participants: [String]
    
    // MARK: - Init
    init(bookingId: String, bookingNumber: String, packageName: String, name: String, dateTime: String, email: String, phoneNumber: String, participants: [String]) {
        self.bookingId = bookingId
        self.bookingNumber = bookingNumber
        self.packageName = packageName
        self.name = name
        self.dateTime = dateTime
        self.email = email
        self.phoneNumber = phoneNumber
        self.participants = participants
    }
    
    
    //        init(booking: Booking, bookingNumber: String) {
    //            self.bookingNumber = bookingNumber
    //            self.packageName = booking.packageName
    //            self.name = booking.userName
    //            self.dateTime = booking.reservationDate
    //            self.email = booking.email
    //            self.phoneNumber = booking.phoneNumber
    //            self.participants = booking.companions.map { $0.fullName }
    //        }
}


//    // MARK: - Properties
//        let bookingNumber: String
//        let packageName: String
//        let name: String
//        let dateTime: String
//        let email: String
//        let phoneNumber: String
//        let participants: [String]
//
//        // MARK: - Init
//        init(bookingNumber: String, packageName: String) {
//            self.bookingNumber = bookingNumber
//            self.packageName = packageName
//            self.name = AppConstant.Instructor.namePlaceholder
//            self.dateTime = AppConstant.Instructor.dateTimePlaceholder
//            self.email = AppConstant.Instructor.emailPlaceholder
//            self.phoneNumber = AppConstant.Instructor.phoneNumberPlaceholder
//            self.participants = [
//                AppConstant.Instructor.participantsPlaceholder,
//                AppConstant.Instructor.participantsPlaceholderTwo,
//                AppConstant.Instructor.participantsPlaceholderThree
//            ]
//        }
//}
