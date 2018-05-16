//
//  postsService.swift
//  Tinsnappook
//
//  Created by Usuario on 10/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class PostsService {    
    private let reference = Database.database().reference(withPath: "posts")
    private let storageReference = Storage.storage().reference(withPath: "posts")
    private var handlesDatabaseReferences = [DatabaseHandle]()
    
    func create(post: Post, _ feedback: @escaping (_ error: Error?, _ reference: DatabaseReference?) -> Void) -> Void {
        let postRef = reference.childByAutoId()
        
        postRef.setValue(post.toAnyObject()) { (error:
            Error?, reference: DatabaseReference) in
            
            feedback(error, reference)
        }
    }
    
    func allPosts(addPost: @escaping (_ post: Post) -> Void) -> Void {
        let handle = reference.observe(.value) { (dataSnapshot: DataSnapshot) in
            for child in dataSnapshot.children {
                if let snapshot = child as? DataSnapshot,
                    var post = Post(snapshot: snapshot) {
                    
                    self.downloadPhoto(uid: post.uid!, { (error, data) in
                        if let data = data {
                            let image = UIImage(data: data)
                            print("Se ha descargado la imagen del post")
                            post.image = image
                        }
                        
                        // Find owner post
                        FriendsService().findBy(uid: post.userID, completion: { (friend) in
                            post.friend = friend
                            addPost(post)
                            return
                        })
                    })
                }
            }
        }
        
        handlesDatabaseReferences.append(handle)
    }
    
    func uploadPhoto(uid: String, dataFile: Data, _ completion: @escaping (Error?) -> Void) {
        let storageRef = storageReference.child("\(uid).jpg")
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object
        let uploadTask = storageRef.putData(dataFile, metadata: metadata)
        
        uploadTask.observe(.success) { (snapshot) in
            // Upload completed successfully
            completion(nil)
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error as NSError? {
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
    
    func downloadPhoto(uid: String, _ completion: @escaping (Error?, Data?) -> Void) {
        let pathReference = storageReference.child("\(uid).jpg")
        
        pathReference.getData(maxSize: INT64_MAX) { (data: Data?, error: Error?) in
           completion(error, data)
        }
    }
    
    func removeReferences() {
        for handle in handlesDatabaseReferences {
            reference.removeObserver(withHandle: handle)
        }
    }
}
