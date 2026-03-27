//
//  StorageService.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/26/25.
//

import UIKit
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage().reference()
    
    /// Upload UIImage and return the download URL
    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "InvalidImage", code: 0)))
                return
            }
            
            let imageRef = storage.child(path)
            
            imageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let urlString = url?.absoluteString else {
                        completion(.failure(NSError(domain: "URLMissing", code: 0)))
                        return
                    }
                    
                    completion(.success(urlString))
                }
            }
        }
}

