//
//  FirestoreService.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import FirebaseFirestore
import FirebaseAuth

final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Create User If Needed
    func createUserIfNeeded(user: User, completion: ((Bool) -> Void)? = nil) {
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                // User doc already exists → do nothing
                completion?(false)
            } else {
                // Create a new user document with default role "user"
                let newUserData: [String: Any] = [
                    "name": user.displayName ?? "",
                    "email": user.email ?? "",
                    "role": "user",
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                userRef.setData(newUserData) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        completion?(false)
                    } else {
                        print("User document created successfully")
                        completion?(true)
                    }
                }
            }
        }
    }
    
    func fetchDivePackages(completion: @escaping ([DivePackage]) -> Void) {
        db.collection(AppConstant.FirestoreKeys.Collections.homepagePackages).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Firestore error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            let packages = documents.compactMap { doc -> DivePackage? in
                let data = doc.data()
                print("Document \(doc.documentID) data: \(data)")
                
                
                let requirements: [String] = [
                    data[AppConstant.FirestoreKeys.Fields.requirements1] as? String ?? "",
                    data[AppConstant.FirestoreKeys.Fields.requirements2] as? String ?? "",
                    data[AppConstant.FirestoreKeys.Fields.requirements3] as? String ?? ""
                ]
                
                return DivePackage(
                    id: doc.documentID,
                    title: data[AppConstant.FirestoreKeys.Fields.title] as? String ?? "",
                    description: data[AppConstant.FirestoreKeys.Fields.description] as? String ?? "",
                    imageUrl: data[AppConstant.FirestoreKeys.Fields.imageUrl] as? String ?? "",
                    price: data[AppConstant.FirestoreKeys.Fields.price] as? String ?? "",
                    isActive: data[AppConstant.FirestoreKeys.Fields.isActive] as? Bool ?? false,
                    totalSlot: data[AppConstant.FirestoreKeys.Fields.totalSlot] as? Int ?? 0,
                    bookedSlot: data[AppConstant.FirestoreKeys.Fields.bookedSlot] as? Int ?? 0,
                    requirements: requirements,
                    disabledReason: data[AppConstant.FirestoreKeys.Fields.disabledReason] as? String ?? ""
                )
            }
            
            completion(packages)
        }
    }
    
    func fetchHomepageData(completion: @escaping ([String]) -> Void) {
        let docRef = db.collection(AppConstant.FirestoreKeys.Collections.homepageData).document(AppConstant.FirestoreKeys.Documents.homepageData)
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching homepage data: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            var galleryImages: [String] = []
            
            if let img1 = data[AppConstant.FirestoreKeys.Fields.image] as? String {
                galleryImages.append(img1)
            }
            if let img2 = data[AppConstant.FirestoreKeys.Fields.imageTwo] as? String {
                galleryImages.append(img2)
            }
            if let img3 = data[AppConstant.FirestoreKeys.Fields.imageThree] as? String {
                galleryImages.append(img3)
            }
            
            completion(galleryImages)
        }
    }
    
    
    func fetchHomepageImages(completion: @escaping (HomePageImages?) -> Void) {
        let docRef = db.collection(AppConstant.FirestoreKeys.Collections.homepageImages)
            .document(AppConstant.FirestoreKeys.Documents.homepageImages)
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching homepage images: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let homepageImages = HomePageImages(
                quote: data[AppConstant.FirestoreKeys.Fields.homepageQuote] as? String ?? "",
                subQuote: data[AppConstant.FirestoreKeys.Fields.homepageSubquote] as? String ?? "",
                imageUrl: data[AppConstant.FirestoreKeys.Fields.imageUrl1] as? String ?? "",
                imageUrlTwo: data[AppConstant.FirestoreKeys.Fields.imageUrl2] as? String ?? "",
                imageUrlThree: data[AppConstant.FirestoreKeys.Fields.imageUrl3] as? String ?? "",
                imageUrlFour: data[AppConstant.FirestoreKeys.Fields.imageUrl4] as? String ?? ""
            )
            
            completion(homepageImages)
        }
    }
}

extension FirestoreService {
    func fetchUserRole(uid: String, completion: @escaping (String) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let role = document.data()?["role"] as? String ?? "user"
                completion(role)
            } else {
                completion("user") // fallback
            }
        }
    }
}

extension FirestoreService {
    func fetchHomepageDestinations(completion: @escaping ([HomepageDestination]) -> Void) {
        db.collection(AppConstant.FirestoreKeys.Collections.homepageDestination).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching homepage destinations: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            var allHomepageDestinations: [HomepageDestination] = []
            
            for doc in documents {
                let data = doc.data()
                var destinationItems: [DestinationItem] = []
                
                // Define keys using AppConstant
                let fieldPairs = [
                    (AppConstant.FirestoreKeys.Fields.destinationImage1, AppConstant.FirestoreKeys.Fields.destinationTitle1),
                    (AppConstant.FirestoreKeys.Fields.destinationImage2, AppConstant.FirestoreKeys.Fields.destinationTitle2),
                    (AppConstant.FirestoreKeys.Fields.destinationImage3, AppConstant.FirestoreKeys.Fields.destinationTitle3),
                    (AppConstant.FirestoreKeys.Fields.destinationImage4, AppConstant.FirestoreKeys.Fields.destinationTitle4),
                    (AppConstant.FirestoreKeys.Fields.destinationImage5, AppConstant.FirestoreKeys.Fields.destinationTitle5)
                ]
                
                for (imageKey, titleKey) in fieldPairs {
                    if let image = data[imageKey] as? String,
                       let title = data[titleKey] as? String,
                       !image.isEmpty, !title.isEmpty {
                        destinationItems.append(DestinationItem(image: image, title: title))
                    }
                }
                
                let homepageDestination = HomepageDestination(
                    id: doc.documentID,
                    destinations: destinationItems
                )
                allHomepageDestinations.append(homepageDestination)
            }
            
            print("Loaded \(allHomepageDestinations.count) homepage destination documents.")
            completion(allHomepageDestinations)
        }
    }
}

extension FirestoreService {
    func fetchHomepageEvents(completion: @escaping ([HomepageEvent]) -> Void) {
        db.collection(AppConstant.FirestoreKeys.Collections.homepageEvent).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching homepage destinations: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            var allHomepageDestinations: [HomepageEvent] = []
            
            for doc in documents {
                let data = doc.data()
                var eventItems: [EventItem] = []
                
                // Define keys using AppConstant
                let fieldPairs = [
                    (AppConstant.FirestoreKeys.Fields.eventImage1, AppConstant.FirestoreKeys.Fields.eventTitle1),
                    (AppConstant.FirestoreKeys.Fields.eventImage2, AppConstant.FirestoreKeys.Fields.eventTitle2),
                    (AppConstant.FirestoreKeys.Fields.eventImage3, AppConstant.FirestoreKeys.Fields.eventTitle3),
                    (AppConstant.FirestoreKeys.Fields.eventImage4, AppConstant.FirestoreKeys.Fields.eventTitle4),
                    (AppConstant.FirestoreKeys.Fields.eventImage5, AppConstant.FirestoreKeys.Fields.eventTitle5)
                ]
                
                for (imageKey, titleKey) in fieldPairs {
                    if let image = data[imageKey] as? String,
                       let title = data[titleKey] as? String,
                       !image.isEmpty, !title.isEmpty {
                        eventItems.append(EventItem(image: image, title: title))
                    }
                }
                
                let homepageEvent = HomepageEvent(
                    id: doc.documentID,
                    events: eventItems
                )
                allHomepageDestinations.append(homepageEvent)
            }
            
            print("Loaded \(allHomepageDestinations.count) homepage destination documents.")
            completion(allHomepageDestinations)
        }
    }
}


