//
//  Post.swift
//  Tinsnappook
//
//  Created by Usuario on 09/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    //let image: UIImage?
    let message: String
    let userID: String
    
    init(message: String, userID: String) {
        self.message = message
        self.userID = userID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let message = value["message"] as? String,
            let userID = value["userID"] as? String else {
                return nil
        }
        
        self.message = message
        self.userID = userID
    }
    
}
