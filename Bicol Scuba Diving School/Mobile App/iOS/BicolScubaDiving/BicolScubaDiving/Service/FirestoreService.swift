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
        db.collection(AppConstant.FirestoreKeys.Collections.homepagePackages).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Firestore error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            let packages = documents.compactMap { doc -> DivePackage? in
                let data = doc.data()
                return DivePackage(
                    id: doc.documentID,
                    title: data[AppConstant.FirestoreKeys.Fields.title] as? String ?? "",
                    description: data[AppConstant.FirestoreKeys.Fields.description] as? String ?? "",
                    imageUrl: data[AppConstant.FirestoreKeys.Fields.imageUrl] as? String ?? "",
                    price: data[AppConstant.FirestoreKeys.Fields.price] as? String ?? "",
                    isActive: data[AppConstant.FirestoreKeys.Fields.isActive] as? Bool ?? false,
                    totalSlot: data[AppConstant.FirestoreKeys.Fields.totalSlot] as? Int ?? 0,
                    bookedSlot: data[AppConstant.FirestoreKeys.Fields.bookedSlot] as? Int ?? 0
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
}
