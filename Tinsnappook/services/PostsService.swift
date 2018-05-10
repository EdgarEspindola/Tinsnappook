//
//  postsService.swift
//  Tinsnappook
//
//  Created by Usuario on 10/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit
import Firebase

class PostsService {    
    private let reference = Database.database().reference(withPath: "posts")
    private var handlesDatabaseReferences = [DatabaseHandle]()
    
    func create(post: Post, _ feedback: @escaping (_ error: Error?) -> Void) -> Void {
        let postRef = reference.childByAutoId()
        
        postRef.setValue(post.toAnyObject()) { (error:
            Error?, reference: DatabaseReference) in
            feedback(error)
        }
    }
    
    func allPosts(clearPosts: @escaping () -> Void, addPost: @escaping (_ post: Post) -> Void) -> Void {
        let handle = reference.observe(.value) { (dataSnapshot: DataSnapshot) in
            clearPosts()
            for child in dataSnapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let post = Post(snapshot: snapshot) {
                    addPost(post)
                }
            }
        }
        
        handlesDatabaseReferences.append(handle)
    }
    
    func removeReferences() {
        for handle in handlesDatabaseReferences {
            reference.removeObserver(withHandle: handle)
        }
    }
}
