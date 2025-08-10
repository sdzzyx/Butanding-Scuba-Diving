//
//  FirestoreService.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchDivePackages(completion: @escaping ([DivePackage]) -> Void) {
        db.collection("homapage-packages").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Firestore error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            let packages = documents.compactMap { doc -> DivePackage? in
                let data = doc.data()
                return DivePackage(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    imageUrl: data["image_url"] as? String ?? "",
                    price: data["price"] as? String ?? "",
                    isActive: data["is_active"] as? Bool ?? false,
                    totalSlot: data["total-slot"] as? Int ?? 0,
                    bookedSlot: data["booked-slot"] as? Int ?? 0
                )
            }
            
            completion(packages)
        }
    }
    
    func fetchHomepageData(completion: @escaping ([String]) -> Void) {
        let docRef = db.collection("homepage-data").document("homepage-data")
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching homepage data: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            var galleryImages: [String] = []
            
            if let img1 = data["image"] as? String {
                galleryImages.append(img1)
            }
            if let img2 = data["imagetwo"] as? String {
                galleryImages.append(img2)
            }
            if let img3 = data["imagethree"] as? String {
                galleryImages.append(img3)
            }
            
            completion(galleryImages)
        }
    }
}
