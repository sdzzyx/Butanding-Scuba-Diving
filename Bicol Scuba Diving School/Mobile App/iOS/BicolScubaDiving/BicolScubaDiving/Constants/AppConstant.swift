//
//  ConstantText.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

class AppConstant {
    struct Configuration {
        static let appEnvironment = "AppEnvironment"
        static let dev = "DEV"
        static let prod = "PROD"
    }
    
    struct Login {
        static let loginTitle = "Login"
        static let forgotPasswordTitle = "Forgot Password?"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        static let footerText = "Don't have an account? Sign up"
    }
    
    struct Welcome {
        
    }
    
    struct SignUp {
        static let signUpTitle = "Sign Up"
        static let submitTitle = "Submit"
        static let firstNamePlaceholder = "First Name"
        static let lastNamePlaceholder = "Last Name"
        static let emailPlaceholder = "Email"
        static let phoneNumberPlaceholder = "Phone Number"
        static let passwordPlaceholder = "Password"
        static let confirmPasswordPlaceholder = "Confirm Password"
        static let footerText = "By joining, you agree with our Terms and Privacy Policy"
    }
    
    struct Profile {
        static let title = "Profile"
        static let accountSettings = "Account Settings"
        static let generalInformation = "General Information"
        static let support = "Support"
        static let personalInfo = "Personal Information"
        static let changePassword = "Change Password"
        static let logout = "Logout"
        static let privacyPolicy = "Privacy Policy"
        static let refundPolicy = "Refund Policy"
        static let termsAndConditions = "Terms & Conditions"
        static let emailUs = "Email Us"
        static let callUs = "Call Us"
        static let followUs = "Follow us on social media"
    }
    
    struct PersonalInformation {
        static let title = "Personal Information"
        static let firstNamePlaceholder = "First Name"
        static let lastNamePlaceholder = "Last Name"
        static let emailPlaceholder = "Email"
        static let phoneNumberPlaceholder = "Phone Number"
        static let updateButtonTitle = "Update"

    }
    
    struct ChangePassword {
        static let title = "Change Password"
        static let oldPasswordPlaceholder = "Old Password"
        static let newPasswordPlaceholder = "New Password"
        static let confirmNewPasswordPlaceholder = "Confirm New Password"
        static let descriptionLabel = "Password must be at least 8 characters long and include an uppercase letter, a number, and a special character."
        static let submitTitle = "Submit"
        
    }
    
    struct Home {
        static let logoImageName = "logo"
        static let notificationImageName = "notification"
        static let greetingText = "Hey John!"
        static let subGreetingText = "What do you need today?"
        static let sectionTitle = "Packages"
        static let viewAllButtonText = "View All"
        static let title = "Swim with the"
        static let subtitle = "Gentle Giants of the Sea"
    }
    
    struct FirestoreKeys {
        struct Collections {
            static let homepagePackages = "homapage-packages"
            static let homepageData = "homepage-data"
        }
        
        struct Documents {
            static let homepageData = "homepage-data"
        }
        
        struct Fields {
            static let title = "title"
            static let description = "description"
            static let imageUrl = "image_url"
            static let price = "price"
            static let isActive = "is_active"
            static let totalSlot = "total-slot"
            static let bookedSlot = "booked-slot"
            static let image = "image"
            static let imageTwo = "imagetwo"
            static let imageThree = "imagethree"
        }
    }
    
    struct Packages {
        static let logo = "logo"
        static let packageTitle = "Diving Packages"
    }
    
    struct PackagesDetail {
        static let logo = "back-detail-logo"
        static let descriptionTitle = "Description"
        static let priceTitle = "Price"
        static let slotTitle = "Slot Available"
        static let bookButtonTitle = "Book"
    }
    
    struct Reservation {
        static let logo = "logo"
        static let reservationTitle = "My Booking"
        
        struct Tabs {
            static let active = "Active"
            static let completed = "Completed"
            static let cancelled = "Cancelled"
        }
    }
}
