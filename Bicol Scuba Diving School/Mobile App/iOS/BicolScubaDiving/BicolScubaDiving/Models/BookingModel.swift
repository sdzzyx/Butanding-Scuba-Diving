//
//  BookingModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/26/25.
//

import Foundation
import FirebaseFirestore

struct Booking: Codable {
    
    let bookingId: String
        let userId: String
        let userName: String
        let email: String
        let phoneNumber: String
        let packageName: String
        let imageUrl: String
        let price: Double
        let paymentAmount: Double
        let paymentMethod: String
        let userMedicalCertificateUrl: String
        let companions: [Companion]
        let reservationDate: String
        let date: Date
        var status: String
        let instructor: String? // optional instructor
    let rescheduleReason: String? // optional because it might not exist
    let rescheduleDate: String?


        
        // MARK: - Firestore dictionary
        var dictionary: [String: Any] {
            return [
                "bookingId": bookingId,
                "userId": userId,
                "userName": userName,
                "email": email,
                "phoneNumber": phoneNumber,
                "packageName": packageName,
                "imageUrl": imageUrl,
                "price": price,
                "paymentAmount": paymentAmount,
                "paymentMethod": paymentMethod,
                "userMedicalCertificateUrl": userMedicalCertificateUrl,
                "companions": companions.map { $0.dictionary },
                "reservationDate": reservationDate,
                "date": Timestamp(date: date),
                "status": status,
                // store null if nil so Firestore shows the field (optional)
                "instructor": instructor ?? NSNull(),
                "rescheduleReason": rescheduleReason ?? NSNull(),
                "rescheduleDate": rescheduleDate ?? NSNull(),

            ]
        }
        
        // MARK: - Firestore Snapshot Initializer
        init?(document: QueryDocumentSnapshot) {
            let data = document.data()
            guard
                let userId = data["userId"] as? String,
                let userName = data["userName"] as? String,
                let email = data["email"] as? String,
                let phoneNumber = data["phoneNumber"] as? String,
                let packageName = data["packageName"] as? String,
                let imageUrl = data["imageUrl"] as? String,
                let price = data["price"] as? Double,
                let paymentAmount = data["paymentAmount"] as? Double,
                let paymentMethod = data["paymentMethod"] as? String,
                let userMedicalCertificateUrl = data["userMedicalCertificateUrl"] as? String,
                let reservationDate = data["reservationDate"] as? String,
                let timestamp = data["date"] as? Timestamp,
                let status = data["status"] as? String
            else {
                return nil
            }
            
            // required fields assigned
            self.bookingId = document.documentID
            self.userId = userId
            self.userName = userName
            self.email = email
            self.phoneNumber = phoneNumber
            self.packageName = packageName
            self.imageUrl = imageUrl
            self.price = price
            self.paymentAmount = paymentAmount
            self.paymentMethod = paymentMethod
            self.userMedicalCertificateUrl = userMedicalCertificateUrl
            self.reservationDate = reservationDate
            self.date = timestamp.dateValue()
            self.status = status
            
            // optional instructor — don't fail if missing
            self.instructor = data["instructor"] as? String
            
            // parse companions safely (assign before finishing initializer)
            if let companionData = data["companions"] as? [[String: Any]] {
                self.companions = companionData.compactMap { Companion(dictionary: $0) }
            } else {
                self.companions = []
            }
            
            self.rescheduleReason = data["rescheduleReason"] as? String
            self.rescheduleDate = data["rescheduleDate"] as? String

        }
        
        // MARK: - Direct Init
        init(
            bookingId: String = UUID().uuidString,
            userId: String,
            userName: String,
            email: String,
            phoneNumber: String,
            packageName: String,
            imageUrl: String,
            price: Double,
            paymentAmount: Double,
            paymentMethod: String,
            userMedicalCertificateUrl: String,
            companions: [Companion],
            reservationDate: String,
            status: String = "Active",
            instructor: String? = nil,
            rescheduleReason: String? = nil, // <-- add this
            rescheduleDate: String? = nil

        ) {
            self.bookingId = bookingId
            self.userId = userId
            self.userName = userName
            self.email = email
            self.phoneNumber = phoneNumber
            self.packageName = packageName
            self.imageUrl = imageUrl
            self.price = price
            self.paymentAmount = paymentAmount
            self.paymentMethod = paymentMethod
            self.userMedicalCertificateUrl = userMedicalCertificateUrl
            self.companions = companions
            self.reservationDate = reservationDate
            self.date = Date()
            self.status = status
            self.instructor = instructor
            self.rescheduleReason = rescheduleReason
            self.rescheduleDate = rescheduleDate
        }
    }

    
    
//    let id: String
//    let userId: String
//    let packageName: String
//    let price: String
//    let status: String
//    let date: Date
//    let imageUrl: String?
//
//    var dictionary: [String: Any] {
//        return [
//            "id": id,
//            "userId": userId,
//            "packageName": packageName,
//            "price": price,
//            "status": status,
//            "date": Timestamp(date: date),
//            "imageUrl": imageUrl ?? "" // Include imageUrl when saving
//        ]
//    }
//
//    // MARK: - Custom Initializer
//    init(id: String, userId: String, packageName: String, price: String, status: String, date: Date, imageUrl: String? = nil) {
//        self.id = id
//        self.userId = userId
//        self.packageName = packageName
//        self.price = price
//        self.status = status
//        self.date = date
//        self.imageUrl = imageUrl
//    }
//    
//    // MARK: - Firestore Snapshot Initializer
//    init?(document: DocumentSnapshot) {
//        let data = document.data() ?? [:]
//        guard
//            let userId = data["userId"] as? String,
//            let packageName = data["packageName"] as? String,
//            let price = data["price"] as? String,
//            let status = data["status"] as? String,
//            let timestamp = data["date"] as? Timestamp
//        else {
//            return nil
//        }
//        
//        self.id = document.documentID
//        self.userId = userId
//        self.packageName = packageName
//        self.price = price
//        self.status = status
//        self.date = timestamp.dateValue()
//        self.imageUrl = data["imageUrl"] as? String // Safely load image URL
//    }
//}

extension Booking {
    /// Returns a copy of this booking with the provided status.
    func with(status newStatus: String) -> Booking {
        return Booking(
            bookingId: self.bookingId,
            userId: self.userId,
            userName: self.userName,
            email: self.email,
            phoneNumber: self.phoneNumber,
            packageName: self.packageName,
            imageUrl: self.imageUrl,
            price: self.price,
            paymentAmount: self.paymentAmount,
            paymentMethod: self.paymentMethod,
            userMedicalCertificateUrl: self.userMedicalCertificateUrl,
            companions: self.companions,
            reservationDate: self.reservationDate,
            status: newStatus,
            instructor: self.instructor
        )
    }
}
