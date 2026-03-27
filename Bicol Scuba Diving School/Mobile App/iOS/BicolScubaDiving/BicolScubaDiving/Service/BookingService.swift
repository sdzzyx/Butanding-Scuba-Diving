//
//  BookingService.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/26/25.
//

import FirebaseFirestore

class BookingService {
    private let db = Firestore.firestore()
    
    /// Saves a booking document to Firestore
    func saveBooking(_ booking: Booking, completion: @escaping (Error?) -> Void) {
        db.collection("bookings").document(booking.bookingId).setData(booking.dictionary) { error in
            if let error = error {
                print("Failed to save booking: \(error.localizedDescription)")
            } else {
                print("Booking successfully saved to Firestore.")
            }
            completion(error)
        }
    }
    
    // Fetch function for instructor booking only
    func fetchBookingsForInstructor(_ instructorId: String, completion: @escaping ([Booking]) -> Void) {
        db.collection("bookings")
            .whereField("assignedInstructorId", isEqualTo: instructorId)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching instructor bookings: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let bookings = snapshot?.documents.compactMap { Booking(document: $0) } ?? []
                print("Loaded \(bookings.count) bookings for instructor: \(instructorId)")
                completion(bookings)
            }
    }
    
    func updateBookingStatus(bookingId: String, newStatus: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("bookings").document(bookingId).updateData(["status": newStatus]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    /// Fetches all bookings for a specific user
    func fetchBookings(for userId: String, completion: @escaping ([Booking]) -> Void) {
        db.collection("bookings")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching bookings: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let bookings = snapshot?.documents.compactMap { Booking(document: $0) } ?? []
                print("Loaded \(bookings.count) bookings for userId: \(userId)")
                completion(bookings)
            }
    }
    
    /// Helper: Save booking based on a DivePackage (auto-fills imageUrl)
    func createBooking(
        from package: DivePackage,
        userId: String,
        userName: String,
        email: String,
        phoneNumber: String,
        paymentAmount: Double,
        paymentMethod: String,
        userMedicalCertificateUrl: String,
        companions: [Companion],
        reservationDate: String,
        status: String = "Pending",
        completion: @escaping (Error?) -> Void)
    {
        let numericPrice = Double(package.price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0.0
        
        
        let booking = Booking(
            bookingId: UUID().uuidString,
            userId: userId,
            userName: userName,
            email: email,
            phoneNumber: phoneNumber,
            packageName: package.title,
            imageUrl: package.imageUrl,
            price: numericPrice, //Double(package.price) ?? 0.0, // ensure this is a Double
            paymentAmount: paymentAmount,
            paymentMethod: paymentMethod,
            userMedicalCertificateUrl: userMedicalCertificateUrl,
            companions: companions,
            reservationDate: reservationDate,
            status: status // Automatically include image URL from the package
        )
        
        saveBooking(booking, completion: completion)
    }
}


extension Notification.Name {
    static let bookingCancelled = Notification.Name("bookingCancelled")
}

