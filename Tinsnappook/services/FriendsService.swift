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
    private let reference = Database.database().reference(withPath: "friends")
    private var handlesDatabaseReferences = [DatabaseHandle]()
 
    func create(friend: Friend, _ feedback: @escaping (_ error: Error?) -> Void) -> Void {
        // Para crear al friend debe existir un usuario logueado
        let friendRef = reference.child(friend.uid!)
        friendRef.setValue(friend.toAnyObject()) { (error:
            Error?, reference: DatabaseReference) in
            feedback(error)
        }
    }
    
    func findBy(post: Post, updateCell: @escaping (_ friend: Friend) -> Void) {
        reference.child(post.userID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            guard let friend = Friend(snapshot: snapshot) else { return }
            updateCell(friend)
        }
    }
}
