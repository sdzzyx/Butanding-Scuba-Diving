//
//  PackageViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/6/25.
//

import Foundation
//import FirebaseFirestoreInternal
import FirebaseFirestore

class PackageViewModel: ObservableObject {
    @Published var packages: [PackageModel] = []
    private var db = Firestore.firestore()
    
    func fetchPackages() {
        db.collection("homepage-packages").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            self.packages = documents.compactMap { doc in
                PackageModel(id: doc.documentID, data: doc.data())
            }
        }
    }
}
