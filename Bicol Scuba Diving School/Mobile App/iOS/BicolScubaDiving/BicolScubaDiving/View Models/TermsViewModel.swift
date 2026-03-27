//
//  TermsViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/27/25.
//

import Foundation

class TermsViewModel {
    
    // The Terms text could be loaded from API or local JSON
    let termsText: String
    
    init(termsText: String = """
    Terms & Privacy Policy
    
    By using the Butanding Scuba Diving Booking App, you agree to our Terms and Privacy Policy.

        • We collect personal information (like name, email, and payment details) to process your bookings.

        • Your information may be shared only with dive operators and payment providers to complete your reservations.

        • You are responsible for providing accurate details and following all safety rules during activities.

        • Diving and butanding encounters involve risks. By booking, you accept these risks.

        • Refunds and cancellations must be made at least 4 days before the scheduled activity to qualify for a refund.
    """) {
        self.termsText = termsText
    }
}
