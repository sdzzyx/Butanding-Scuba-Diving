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
    
    struct Welcome {
        let image: UIImage
        let title: String
        let subtitle: String
        let description: String
    }
    
    struct SignUp {
        
    }
}

// MARK: Custom Blue color
extension UIColor {
    static let customBlue = UIColor(red: 43/255, green: 92/255, blue: 167/255, alpha: 1)
}
