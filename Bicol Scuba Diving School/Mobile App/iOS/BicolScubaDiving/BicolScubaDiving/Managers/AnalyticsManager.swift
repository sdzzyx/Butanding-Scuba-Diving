//
//  AnalyticsManager.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 9/8/25.
//

import Foundation
import FirebaseAnalytics

/// A centralized wrapper for Firebase Analytics
/// ---------------------------------------------------------
/// Best Practice Usage:
/// ViewController → Screen tracking & UI interactions
/// ViewModel → Business logic events (purchases, API-driven events, feature usage) 
///
/// Usage:
/// 1. Initialize Firebase in AppDelegate:
///    FirebaseApp.configure()
///
/// 2. Log screen views:
///    FirebaseAnalyticsManager.shared.logScreenView(
///        screenName: "Home Screen",
///        screenClass: String(describing: type(of: self))
///    )
///
/// 3. Log custom events:
///    FirebaseAnalyticsManager.shared.logEvent(
///        name: "button_click",
///        parameters: ["button_name": "Start Now"]
///    )
///
/// 4. Set user properties:
///    FirebaseAnalyticsManager.shared.setUserProperty("premium", forName: "subscription_type")
///
/// 5. Set user ID (for logged-in users):
///    FirebaseAnalyticsManager.shared.setUserID("12345")
///
///
/// 6. FirebaseAnalyticsManager.shared.logPurchase(
///     packageName: "Gold Membership",
///     price: 29.99,
///     currency: "USD",
///     paymentMethod: "GCash",
///     packageId: "com.myapp.gold"
///   )

/// This wrapper ensures all Firebase Analytics calls
/// are centralized, consistent, and easy to maintain.
/// ---------------------------------------------------------

final class FirebaseAnalyticsManager {
    
    // MARK: - Singleton
    static let shared = FirebaseAnalyticsManager()
    private init() {}

    // MARK: - Screen Tracking
    /// Logs a screen view event
    /// - Parameters:
    ///   - screenName: Name of the screen
    ///   - screenClass: ViewController class name (default: "")
    func logScreenView(screenName: String, screenClass: String = "") {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }
    
    // MARK: - Custom Events
    /// Logs a custom event with optional parameters
    /// - Parameters:
    ///   - name: Name of the event
    ///   - parameters: Dictionary of event parameters
    func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    // MARK: - User Properties
    /// Sets a user property to a given value
    /// - Parameters:
    ///   - value: Value of the property
    ///   - name: Name of the property
    func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    // MARK: - User ID
    /// Assigns a user identifier for logged-in users
    /// - Parameter id: User ID
    func setUserID(_ id: String?) {
        Analytics.setUserID(id)
    }
    
    // MARK: - Payment Tracking
    /// Logs a purchase/payment event
    /// - Parameters:
    ///   - packageName: The name of the purchased package (ex: "Premium Plan")
    ///   - price: The amount paid
    ///   - currency: Currency code (default "PHP")
    ///   - paymentMethod: Payment method used (ex: "GCash", "PayPal", "Cash")
    ///   - packageId: Optional product/package identifier (ex: "com.myapp.gold")
    func logPurchase(
        packageName: String,
        price: Double,
        currency: String = "PHP",
        paymentMethod: String,
        packageId: String? = nil
    ) {
        var parameters: [String: Any] = [
            AnalyticsParameterItemName: packageName,
            AnalyticsParameterValue: price,
            AnalyticsParameterCurrency: currency,
            "payment_method": paymentMethod   // Custom parameter
        ]
        
        if let packageId = packageId {
            parameters["package_id"] = packageId
        }
        
        Analytics.logEvent(AnalyticsEventPurchase, parameters: parameters)
    }
    
    
    /// Logs API error events
    /// - Parameters:
    ///   - endpoint: API endpoint that caused the error
    ///   - statusCode: HTTP status code or custom error code
    ///   - message: Optional error message
    ///   - screen: Optional screen where the error occurred
    func logApiError(
            endpoint: String,
            statusCode: Int,
            message: String? = nil,
            screen: String? = nil
        ) {
            var parameters: [String: Any] = [
                "endpoint": endpoint,
                "status_code": statusCode
            ]
            
            if let message = message {
                parameters["error_message"] = message
            }
            
            if let screen = screen {
                parameters["screen"] = screen
            }
            
            logEvent(name: "api_error", parameters: parameters)
        }
}
