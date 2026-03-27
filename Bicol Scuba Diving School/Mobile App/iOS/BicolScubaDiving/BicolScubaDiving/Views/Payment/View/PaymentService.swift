//
//  PaymentService.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/19/25.
//

import Foundation
import FirebaseFunctions

final class PaymentService {
    
    private lazy var functions = Functions.functions()
    
    // MARK: - Create payments for all packages
        func createGcashPaymentsForAllPackages(email: String, completion: @escaping (Result<[String], Error>) -> Void) {
            // 1️⃣ Fetch all packages from Firestore
            FirestoreService.shared.fetchDivePackages { packages in
                guard !packages.isEmpty else {
                    completion(.failure(NSError(domain: "NoPackages",
                                                code: 0,
                                                userInfo: [NSLocalizedDescriptionKey: "No dive packages found."])))
                    return
                }

                var redirectUrls: [String] = []
                let dispatchGroup = DispatchGroup()

                // 2️⃣ Loop over each package and create a GCash payment source
                for package in packages {
                    dispatchGroup.enter()

                    let amount = Double(package.price) ?? 0.0
                    let description = package.title

                    let data: [String: Any] = [
                        "amount": amount,
                        "description": description,
                        "email": email,
                        "packageId": package.id // ✅ Send package ID to Cloud Function
                    ]

                    // Call your deployed Firebase Function
                    self.functions.httpsCallable("createGcashPaymentSource").call(data) { result, error in
                        if let error = error {
                            print("❌ Payment creation failed for \(package.id): \(error.localizedDescription)")
                            dispatchGroup.leave()
                            return
                        }

                        if let responseData = result?.data as? [String: Any],
                           let redirectUrl = responseData["redirectUrl"] as? String {
                            redirectUrls.append(redirectUrl)
                        }
                        dispatchGroup.leave()
                    }
                }

                // 3️⃣ Return all redirect URLs once all requests are done
                dispatchGroup.notify(queue: .main) {
                    if redirectUrls.isEmpty {
                        completion(.failure(NSError(domain: "PaymentError",
                                                    code: 0,
                                                    userInfo: [NSLocalizedDescriptionKey: "No payments created."])))
                    } else {
                        completion(.success(redirectUrls))
                    }
                }
            }
        }
        
    func createGcashPayment(packageId: String, amount: Double, description: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard amount > 0 && amount <= 100000 else {
            completion(.failure(NSError(domain: "InvalidAmount", code: -1, userInfo: [NSLocalizedDescriptionKey: "Amount must be between 1 and 100,000 PHP."])))
            return
        }

        let data: [String: Any] = [
            "packageId": packageId,
            "amount": amount,
            "description": description,
            "email": email
        ]

        functions.httpsCallable("createGcashPaymentSource").call(data) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let responseData = result?.data as? [String: Any],
                  let redirectUrl = responseData["redirectUrl"] as? String else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from payment service."])))
                return
            }

            completion(.success(redirectUrl))
            }
        }
        
//    private lazy var functions = Functions.functions()
//    
//    func createGcashPayment(amount: Double, completion: @escaping (Result<String, Error>) -> Void) {
//        let amountInCentavos = Int(amount * 100)
//        let data: [String: Any] = ["amount": amountInCentavos]
//        
//        print("📤 Sending request to Firebase Function with amount: \(amountInCentavos)")
//        
//        functions.httpsCallable("createGcashPaymentIntent").call(data) { result, error in
//            if let error = error {
//                print("❌ Firebase Function error:", error.localizedDescription)
//                completion(.failure(error))
//                return
//            }
//            
//            print("✅ Firebase Function result:", result?.data ?? "No data")
//            
//            guard
//                let responseData = result?.data as? [String: Any],
//                let dataDict = responseData["data"] as? [String: Any],
//                let attributes = dataDict["attributes"] as? [String: Any],
//                let clientKey = attributes["client_key"] as? String,
//                let paymentIntentId = dataDict["id"] as? String
//            else {
//                print("⚠️ Invalid Firebase response structure:", result?.data ?? "nil")
//                completion(.failure(NSError(domain: "InvalidResponse", code: -1)))
//                return
//            }
//            
//            print("🧾 PaymentIntent ID:", paymentIntentId)
//            print("🔑 Client Key:", clientKey)
//            
//            self.createPaymentMethod(
//                clientKey: clientKey,
//                paymentIntentId: paymentIntentId,
//                completion: completion
//            )
//        }
//    }
//    
//    private func createPaymentMethod(
//        clientKey: String,
//        paymentIntentId: String,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        let publicKey = "pk_test_sgePrHJbD41mHGZKVnDyUtNw" // Replace with your PayMongo Public Key
//        guard let url = URL(string: "https://api.paymongo.com/v1/payment_methods") else { return }
//        
//        print("📤 Creating payment method in PayMongo…")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue(
//            "Basic " + Data("\(publicKey):".utf8).base64EncodedString(),
//            forHTTPHeaderField: "Authorization"
//        )
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let payload: [String: Any] = [
//            "data": [
//                "attributes": [
//                    "type": "gcash",
//                    "billing": [
//                        "name": "Test User",
//                        "email": "test@example.com",
//                        "phone": "09000000000"
//                    ]
//                ]
//            ]
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Error creating payment method:", error.localizedDescription)
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                print("⚠️ No response data from PayMongo payment_methods")
//                completion(.failure(NSError(domain: "EmptyResponse", code: -10)))
//                return
//            }
//            
//            guard
//                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let paymentData = json["data"] as? [String: Any],
//                let paymentId = paymentData["id"] as? String
//            else {
//                completion(.failure(NSError(domain: "InvalidPaymentMethod", code: -2)))
//                return
//            }
//            
//            print("✅ Payment Method Created with ID:", paymentId)
//            
//            self.attachPaymentMethod(
//                paymentId: paymentId,
//                clientKey: clientKey,
//                paymentIntentId: paymentIntentId,
//                completion: completion
//            )
//        }.resume()
//    }
//    
//    private func attachPaymentMethod(
//        paymentId: String,
//        clientKey: String,
//        paymentIntentId: String,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        guard let url = URL(string: "https://api.paymongo.com/v1/payment_intents/\(paymentIntentId)/attach") else { return }
//        
//        print("🔗 Attaching payment method \(paymentId) to intent \(paymentIntentId)")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(
//            "Basic " + Data("\(clientKey):".utf8).base64EncodedString(),
//            forHTTPHeaderField: "Authorization"
//        )
//        
//        let payload: [String: Any] = [
//            "data": [
//                "attributes": [
//                    "payment_method": paymentId,
//                    "return_url": "butandingscubadiving://payment-success"
//                ]
//            ]
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "EmptyAttachResponse", code: -20)))
//                return
//            }
//            
//            guard
//                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let dataDict = json["data"] as? [String: Any],
//                let attributes = dataDict["attributes"] as? [String: Any],
//                let nextAction = attributes["next_action"] as? [String: Any],
//                let redirect = nextAction["redirect"] as? [String: Any],
//                let redirectUrl = redirect["url"] as? String
//            else {
//                completion(.failure(NSError(domain: "InvalidAttachResponse", code: -3)))
//                return
//            }
//            
//            completion(.success(redirectUrl))
//        }.resume()
//    }
}
