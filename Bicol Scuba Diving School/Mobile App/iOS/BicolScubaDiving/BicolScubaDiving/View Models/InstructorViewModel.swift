//
//  InstructorViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/14/25.
//

import Foundation
import FirebaseAuth

class InstructorViewModel {
    
    let greetingText: String
    let assignedBookingTitle: String
    //let instructorBookingViewModel: InstructorBookingViewModel
    
    init() {
        // Get full name from FirebaseAuth
        let fullName = Auth.auth().currentUser?.displayName
        if let name = fullName, !name.isEmpty {
            // Extract first name
            let firstName = name.components(separatedBy: " ").first ?? name
            greetingText = "\(AppConstant.Instructor.greetingText)\(firstName)!"
        } else {
            greetingText = "\(AppConstant.Instructor.greetingText)!"
        }

        assignedBookingTitle = AppConstant.Instructor.assignedBookingTitle
        //instructorBookingViewModel = InstructorBookingViewModel()
    }
}
