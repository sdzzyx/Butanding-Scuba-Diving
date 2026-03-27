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
    
    struct Instructor {
        static let instructorTitle = "Instructor Dashboard"
        static let logo = "logo"
        static let backLogo = "back-logo"
        static let greetingText = "Welcome Instructor "
        static let assignedBookingTitle = "Assigned Bookings"
        static let expandedSymbol = "▶"
        static let collapseSymbol = "▼"
        static let bookingNumberTitle = "Booking Number:"
        static let bookingOneTitle = "Booking #0001"
        static let packageInformationTitle = "Package Information"
        static let packageTitle = "Package:"
        static let packageName = "Discover Scuba Diving"
        static let nameTitle = "Name:"
        static let namePlaceholder = "Juan Dela Cruz"
        static let dateTimeTitle = "Date & Time:"
        static let dateTimePlaceholder = "October 20, 2025 - 10:00 AM"
        static let participantsTitle = "Participants:"
        static let emailTitle = "Email:"
        static let emailPlaceholder = "juan@gmail.com"
        static let phoneNumberTitle = "Phone Number:"
        static let phoneNumberPlaceholder = "09477601772"
        static let participantsPlaceholder = "1. Maria Santos"
        static let participantsPlaceholderTwo = "2. Ana Reyes"
        static let participantsPlaceholderThree = "3. Jake Dela Cruz"
        static let bookingDetailsTitle = "Booking Details"
        static let buttonTitle = "Completed"
        static let bookingScheduleTitle = "Booking Schedules"
    
    }
    
    struct BookingDetails {
        static let bookingDetailsTitle = "Booking Details"
        static let backLogo = "back-logo"
        static let packageName = "Discover Scuba Diving"
        static let pendingTitle = "Pending"
        static let approvedTitle = "Approved"
        static let cancelTitle = "Canceled"
        static let bookingNumberTitle = "Booking Number:"
        static let bookingPlaceholder = "Booking #0001"
        static let dateTitle = "Reservation Date:"
        static let datePlaceholder = "October 20, 2025"
        static let priceTitle = "Price:"
        static let pricePlaceholder = "Php 2,500.00"
        static let assignedInstructor = "Assigned Instructor:"
        static let buttonTitle = "Cancel"
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
        static let greetingText = "Hey"
        static let subGreetingText = "What do you need today?"
        static let sectionTitle = "Packages"
        static let viewAllButtonText = "View All"
        static let title = "Swim with the"
        static let subtitle = "Gentle Giants of the Sea"
        static let destinationTitle = "Other Destinations"
        static let eventTitle = "Festivals / Events"
    }
    
    struct FirestoreKeys {
        struct Collections {
            static let homepagePackages = "homapage-packages"
            static let homepageData = "homepage-data"
            static let homepageDestination = "homepage-destination"
            static let homepageEvent = "homepage-event"
            static let homepageImages = "homepage-images"
        }
        
        struct Documents {
            static let homepageData = "homepage-data"
            static let homepageImages = "homepage-images"
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
            
            static let destinationImage1 = "destination_image1"
            static let destinationTitle1 = "destination_title1"
            
            static let destinationImage2 = "destination_image2"
            static let destinationTitle2 = "destination_title2"
            
            static let destinationImage3 = "destination_image3"
            static let destinationTitle3 = "destination_title3"
            
            static let destinationImage4 = "destination_image4"
            static let destinationTitle4 = "destination_title4"
            
            static let destinationImage5 = "destination_image5"
            static let destinationTitle5 = "destination_title5"
            
            static let eventImage1 = "event_image1"
            static let eventTitle1 = "event_title1"
            
            static let eventImage2 = "event_image2"
            static let eventTitle2 = "event_title2"
            
            static let eventImage3 = "event_image3"
            static let eventTitle3 = "event_title3"
            
            static let eventImage4 = "event_image4"
            static let eventTitle4 = "event_title4"
            
            static let eventImage5 = "event_image5"
            static let eventTitle5 = "event_title5"
            
            static let homepageQuote = "homepage-quote"
            static let homepageSubquote = "homepage-subquote"
            static let imageUrl1 = "image-url"
            static let imageUrl2 = "image-url2"
            static let imageUrl3 = "image-url3"
            static let imageUrl4 = "image-url4"
            
            static let disabledReason = "disabled_reason"

            
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
        static let termsAndPrivacyPolicyTitle = "I agree to the Terms and Privacy Policy"
        static let checkBoxUnfilled = "check_box_unfilled"
        static let checkBoxFilled = "check_box_filled"
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
    
    struct CashConfirmation {
        static let logo = "logo"
        static let bookingHeader = "Booking Successfull!"
        static let thankYouLabel = "Thank you!"
        static let details = "We have recieve your booking information, Please prepare the exact amount and pay directly at the facility."
        static let homeButtonTitle = "Home"
    }
    
    struct PaymentConfirmation {
        static let logo = "logo"
        static let bookingHeader = "Payment Successfull!"
        static let thankYouLabel = "Thank you!"
        static let details = "We have recieved your booking information."
        static let homeButtonTitle = "Home"
    }
}
