//
//  Friend.swift
//  Tinsnappook
//
//  Created by Usuario on 10/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import Foundation
import Firebase

struct Friend {
    let uid: String?
    let userName: String
    //let photoURL: String
    //let genero: Bool
    //let dateBirth: String
    
    init(uid: String?, userName: String) {
        self.userName = userName
        self.uid = uid
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["userName"] as? String else {
                return nil
        }
        
        self.uid = snapshot.key
        self.userName = userName        
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName
        ]
    }
}
