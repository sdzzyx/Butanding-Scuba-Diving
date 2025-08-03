//
//  PersonalInformationViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import Foundation
import UIKit

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
    
    init() {
        self.personalInfomation = PersonalInformationModel(
            firstname: "Juan",
            lastname: "Dela Cruz",
            email: "juandelacruz@gmail.com",
            phoneNumber: "0917 120 4843"
        )
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
    
    func updateFirstName(_ firstName: String) {
        personalInfomation.firstname = firstName
        infoUpdated?()
    }
    
    func saveChanges() {
        print("Updated Information Saved!")
    }
}
