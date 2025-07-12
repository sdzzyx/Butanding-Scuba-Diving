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
    
    struct SignUp {
        static let signUpTitle = "Sign Up"
        static let submitTitle = "Submit"
        static let firstNamePlaceholder = "First Name"
        static let lastNamePlaceholder = "Last Name"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        static let confirmPasswordPlaceholder = "Confirm Password"
        static let footerText = "By joining, you agree with our Terms and Privacy Policy"
    }
    
    struct Profile{
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
}
