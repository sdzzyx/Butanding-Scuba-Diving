//
//  ConstantText.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

class AppConstant {
    
    struct Analytics {
        
        struct EventName {
            static let click = "click"
            static let view = "view"
            static let tryAgain = "try_again"
            static let next = "next"
            static let purchase = "purchase"
        }
        
        struct Parameter {
            static let screen = "screen"
            static let buttonName = "button_name"
            static let itemId = "item_id"
            static let price = "price"
            static let currency = "currency"
            static let paymentMethod = "payment_method"
        }
        
        struct Endpoint {
            static let loginWithGoogle = "Login with Google"
            static let loginWithApple = "Login with Apple"
            static let loginWithFacebook = "Login with Facebook"
            static let loginWithEmail = "Login with Email"
        }
        
        struct SplashScreen {
            static let screen = "Splash"
        }
        
        struct LoginScreen {
            static let screen = "Login"
            static let buttonLogin = "Login"
            static let buttonForgotPassword = "Forgot Password"
            static let buttonSignUp = "Sign Up"
            static let buttonGoogle = "Login with Google"
            static let buttonApple = "Login with Apple"
            static let buttonFacebook = "Login with Facebook"
        }
        
        struct SignUpScreen {
            
        }
        
        struct WelcomeScreen {
            static func screen(_ page: Int) -> String {
                return "Welcome Screen Page \(page)"
            }
            
            static let buttonGetStarted = "Let's Get Started"
        }
        
        struct HomeScreen {
            
        }
        
        struct ProfileScreen {
            
        }
    }
    
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
            
            static let requirements1 = "requirements1"
            static let requirements2 = "requirements2"
            static let requirements3 = "requirements3"
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
        static let requirementsTitle = "Requirements"
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
    
    struct Booking {
        static let logo = "logo"
        static let bookingTitle = "Booking"
        static let informationTitle = "Information"
        static let nameTitle = "Name:"
        static let emailTitle = "Email:"
        static let namePlaceholder = "Juan Dela Cruz"
        static let emailPlaceholder = "juan@example.com"
        static let dateReservationTitle = "Date of Reservation"
        static let preferreDateTitle = "Preferred Date:"
        static let preferredDatePlaceholder = "Tap to select available date"
        static let additionalInformationTitle = "Additional Information"
        static let mobileNumberTitle = "Mobile Number:"
        static let mobileNumberPlaceholder = "Tap to select Mobile Number"
        static let amountTitle = "Amount"
        static let priceTitle = "Price:"
        static let continueButtonTitle = "Continue"
        
        static let numberOfCompanionTitle = "Number of Companion"
        static let numberOfCompanionPlaceHolder = "Tap to select number of companion"
        static let companionTitle = "Companion"
        static let fullNameTitle = "Full Name:"
        static let medicalCertificateTitle = "Medical Certificate:"
        static let fullNamePlaceholder = "Tap to enter Full Name"
        static let uploadCertificateButtonTitle = "Upload Certificate"
        static let expandedSymbol = "▶"
        static let collapseSymbol = "▼"
        static let companionTitlePlaceholder = "▶ Companion"
        static let certificateUploadedTitle = "Certificate Uploaded"
    }
    
    struct Payment {
        static let logo = "logo"
        static let paymentTitle = "Payment Method"
        static let cashTitle = "Cash"
        static let cashPaymentTitle = "Cash"
        static let cashLogo = "cash-logo"
        static let morePaymentOptionsTitle = "More Payment Options"
        static let gcashLogo = "gcash-logo"
        static let paypalLogo = "paypal-logo"
        static let continueButtonTitle = "Continue"
        static let paymentHighlightsTitle = "Payment"
        static let methodHighlightsTitle = "Method"
    }
}
