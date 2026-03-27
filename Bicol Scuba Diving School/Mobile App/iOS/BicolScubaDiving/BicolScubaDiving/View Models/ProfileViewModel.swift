//
//  ProfileViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/13/25.
//

import UIKit
import FirebaseAuth

class ProfileViewModel {
    let logoImage: UIImage
    let title: String
    let sections: [ProfileSection]
    let socialIcons: [UIImage]
    
    init(
        logoImage: UIImage = UIImage(named: "logo") ?? UIImage(),
        title: String = AppConstant.Profile.title,
        sections: [ProfileSection]? = nil,
        socialIcons: [UIImage]? = nil
    ) {
        self.logoImage = logoImage
        self.title = title
        
        
        let isEmailPasswordUser = Auth.auth().currentUser?.isEmailPasswordUser ?? false
        
        if let sections = sections {
                    self.sections = sections
                } else {
                    var accountItems = [
                        ProfileItem(title: AppConstant.Profile.personalInfo),
                        ProfileItem(title: AppConstant.Profile.logout)
                    ]
                    
                    if isEmailPasswordUser {
                        accountItems.insert(ProfileItem(title: AppConstant.Profile.changePassword), at: 1)
                    }
                    
                    self.sections = [
                        ProfileSection(sectionTitle: AppConstant.Profile.accountSettings, items: accountItems),
                        ProfileSection(sectionTitle: AppConstant.Profile.generalInformation, items: [
                            ProfileItem(title: AppConstant.Profile.privacyPolicy),
                            ProfileItem(title: AppConstant.Profile.refundPolicy),
                            ProfileItem(title: AppConstant.Profile.termsAndConditions)
                        ]),
                        ProfileSection(sectionTitle: AppConstant.Profile.support, items: [
                            ProfileItem(title: AppConstant.Profile.emailUs),
                            ProfileItem(title: AppConstant.Profile.callUs)
                        ])
                    ]
                }
        

        if let socialIcons = socialIcons {
            self.socialIcons = socialIcons
        } else {
            self.socialIcons = [
                UIImage(named: "footer-facebook") ?? UIImage(),
                UIImage(named: "footer-twitter") ?? UIImage(),
                UIImage(named: "footer-instagram") ?? UIImage()
            ]
        }
    }
}

extension User {
    var isEmailPasswordUser: Bool {
        return providerData.contains { $0.providerID == "password" }
    }
}
