//
//  ConstantText.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//
import UIKit

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
}
