//
//  CompanionModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/16/25.
//
import UIKit
import Foundation
import FirebaseFirestore

struct Companion : Codable { // : Codable
    
    
    var fullName: String
        var medicalCertificateUrl: String?
        
        var dictionary: [String: Any] {
            return [
                "fullName": fullName,
                "medicalCertificateUrl": medicalCertificateUrl ?? ""
            ]
        }
        
        init(fullName: String = "", medicalCertificateUrl: String = "") {
            self.fullName = fullName
            self.medicalCertificateUrl = medicalCertificateUrl
        }
        
        init?(dictionary: [String: Any]) {
            
            guard let fullName = dictionary["fullName"] as? String else { return nil }
                    self.fullName = fullName
                    self.medicalCertificateUrl = dictionary["medicalCertificateUrl"] as? String
//            guard let fullName = dictionary["fullName"] as? String,
//                  let medicalCertificateUrl = dictionary["medicalCertificateUrl"] as? String else {
//                return nil
//            }
//            self.fullName = fullName
//            self.medicalCertificateUrl = medicalCertificateUrl
        }
    
    
    
//    var fullName: String = ""
//    var medicalCertificate: UIImage? = nil
    
    
    
    
//    var fullName: String = ""
//        var medicalCertificateUrl: String? = nil
//
//    var dictionary: [String: Any] {
//            return [
//                "fullName": fullName,
//                "medicalCertificateUrl": medicalCertificateUrl ?? ""
//            ]
//        }
//
//        init(fullName: String = "", medicalCertificateUrl: String? = nil) {
//            self.fullName = fullName
//            self.medicalCertificateUrl = medicalCertificateUrl
//        }
//
//        init?(dictionary: [String: Any]) {
//            self.fullName = dictionary["fullName"] as? String ?? ""
//            self.medicalCertificateUrl = dictionary["medicalCertificateUrl"] as? String
//        }
    
}
