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
    
    let reference = Database.database().reference(withPath: "posts")
    
    func create(post: Post, _ feedback: @escaping (_ error: Error?) -> Void) {
        let postRef = reference.childByAutoId()
        postRef.setValue(post.toAnyObject()) { (error:
            Error?, reference: DatabaseReference) in
            feedback(error)
        }
    }
}
