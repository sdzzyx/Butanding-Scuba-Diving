//
//  InstructorBookingViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/14/25.
//
import Foundation

class InstructorBookingViewModel {
    
    let bookingId: String
        let packageName: String
        let reservationDate: String
        let participants: [String]
    let instructorName: String?
        
        var isExpanded: Bool = false
        
    init(bookingId: String, packageName: String, reservationDate: String, participants: [String], instructorName: String?) {
            self.bookingId = bookingId
            self.packageName = packageName
            self.reservationDate = reservationDate
            self.participants = participants
        self.instructorName = instructorName
        }
    }
    
    
//    let bookingOneTitle: String
//    let packageTitle: String
//    let packageName: String
//    let nameTitle: String
//    let namePlaceholder: String
//    let dateTimeTitle: String
//    let dateTimePlaceholder: String
//    let participantsTitle: String
//    let participantsPlaceholder: String
//    let participantsPlaceholderTwo: String
//    let participantsPlaceholderThree: String
//    
//    var isExpanded: Bool = false
//    
//    init() {
//        bookingOneTitle = AppConstant.Instructor.bookingOneTitle
//        packageTitle = AppConstant.Instructor.packageTitle
//        packageName = AppConstant.Instructor.packageName
//        nameTitle = AppConstant.Instructor.nameTitle
//        namePlaceholder = AppConstant.Instructor.namePlaceholder
//        dateTimeTitle = AppConstant.Instructor.dateTimeTitle
//        dateTimePlaceholder = AppConstant.Instructor.dateTimePlaceholder
//        participantsTitle = AppConstant.Instructor.participantsTitle
//        participantsPlaceholder = AppConstant.Instructor.participantsPlaceholder
//        participantsPlaceholderTwo = AppConstant.Instructor.participantsPlaceholderTwo
//        participantsPlaceholderThree = AppConstant.Instructor.participantsPlaceholderThree
//    }
//}
