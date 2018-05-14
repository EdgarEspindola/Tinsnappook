//
//  FriendsService.swift
//  Tinsnappook
//
//  Created by Usuario on 10/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class FriendsService {
    static let defaultPath = "friends"
    
    private let databaseReference = Database.database().reference(withPath: defaultPath)
    private let storageReference = Storage.storage().reference(withPath: defaultPath)
    private var handlesDatabaseReferences = [DatabaseHandle]()
 
    func create(friend: Friend, _ feedback: @escaping (_ error: Error?) -> Void) -> Void {
        // Para crear al friend debe existir un usuario logueado
        let friendRef = databaseReference.child(friend.uid!)
        friendRef.setValue(friend.toAnyObject()) { (error:
            Error?, reference: DatabaseReference) in
            feedback(error)
        }        
    }
    
    func findBy(uid: String, completion: @escaping (_ friend: Friend) -> Void) {
        databaseReference.child(uid).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            guard let friend = Friend(snapshot: snapshot) else { return }
            completion(friend)
        }
    }
    
    func uploadPhotoProfile(uid: String, dataFile: Data, _ completion: @escaping (Error?) -> Void) {
        let friendRef = storageReference.child(uid).child("profile-photo.jpg")
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object
        let uploadTask = storageReference.putData(dataFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { (snapshot) in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { (snapshot) in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
        }
        
        uploadTask.observe(.success) { (snapshot) in
            // Upload completed successfully
            completion(nil)
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn´t exist
                    break
                case .unauthorized:
                    // User doesn´t have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ......  */
                case .unknown:
                    // Unknown error ocurred, inspect the server response
                    completion(error)
                    break
                default:
                    // A separate error ocurred. This is a good place to retry the upload.
                    completion(error)
                    break
                }
            }
        }
    }

    func downloadPhotoProfile(uid: String, _ completion: @escaping (Error?) -> Void) {
        let pathReference = storageReference.child(uid).child("profile-photo.jpg")
        
        pathReference.getData(maxSize: 100 * 1024 * 1024) { (data: Data?, error: Error?) in
//            if let error = error {
//                // Uh-oh, an error ocurred!
//            } else {
//                // Data for es returned
//                let image = UIImage(data: data!)
//            }
            completion(error)
        }
    }
    
}
