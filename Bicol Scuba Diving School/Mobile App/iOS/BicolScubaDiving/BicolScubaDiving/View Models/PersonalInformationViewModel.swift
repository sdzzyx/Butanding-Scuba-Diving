//
//  PersonalInformationViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct PersonalInformationViewData {
    let backLogoImage: UIImage?
    let title: String
    let firstNameTitle: String
    let lastNameTitle: String
    let emailTitle: String
    let phoneTitle: String
    let updateButtonTitle: String
}

class PersonalInformationViewModel {
    
    var personalInfomation: PersonalInformationModel
    
    var infoUpdated: (() -> Void)?
    
    private let db = Firestore.firestore()
    
    init() {
        self.personalInfomation = PersonalInformationModel(
            firstname: "",
            lastname: "",
            email: "",
            phoneNumber: ""
        )
        
        loadUserInfo()
    }
    
    var viewData: PersonalInformationViewData {
        return PersonalInformationViewData(
            backLogoImage: UIImage(named: "back-logo"),
            title: AppConstant.PersonalInformation.title,
            firstNameTitle: personalInfomation.firstname,
            lastNameTitle: personalInfomation.lastname,
            emailTitle: personalInfomation.email,
            phoneTitle: personalInfomation.phoneNumber,
            updateButtonTitle: AppConstant.PersonalInformation.updateButtonTitle
        )
    }
    
    // ✅ Fetch from FirebaseAuth
    private func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
                
                // Load from Auth
                let nameComponents = user.displayName?.split(separator: " ") ?? []
                personalInfomation.firstname = nameComponents.first.map(String.init) ?? ""
                personalInfomation.lastname = nameComponents.dropFirst().joined(separator: " ")
                personalInfomation.email = user.email ?? ""
                personalInfomation.phoneNumber = user.phoneNumber ?? ""
                
                // ✅ Load additional info from Firestore if available
                db.collection("users").document(user.uid).getDocument { [weak self] snapshot, error in
                    guard let data = snapshot?.data(), error == nil else { return }
                    
                    self?.personalInfomation.firstname = data["firstname"] as? String ?? self?.personalInfomation.firstname ?? ""
                    self?.personalInfomation.lastname = data["lastname"] as? String ?? self?.personalInfomation.lastname ?? ""
                    self?.personalInfomation.phoneNumber = data["phone"] as? String ?? self?.personalInfomation.phoneNumber ?? ""
                    
                    self?.infoUpdated?()
                }
                
                infoUpdated?()
    }
    
    func updateFirstName(_ firstName: String) {
        personalInfomation.firstname = firstName
        infoUpdated?()
    }
    
    func updateLastName(_ lastName: String) {
        personalInfomation.lastname = lastName
        infoUpdated?()
    }
    
    func updatePhone(_ phone: String) {
        personalInfomation.phoneNumber = phone
        infoUpdated?()
    }
    
    func saveChanges() {
        guard let user = Auth.auth().currentUser else { return }
        
        let data: [String: Any] = [
            "firstname": personalInfomation.firstname,
            "lastname": personalInfomation.lastname,
            "email": personalInfomation.email,
            "phone": personalInfomation.phoneNumber
        ]
        
        db.collection("users").document(user.uid).setData(data, merge: true) { error in
            if let error = error {
                print("Failed to save user info: \(error.localizedDescription)")
            } else {
                print("User info successfully saved to Firestore")
            }
        }
    }
}
