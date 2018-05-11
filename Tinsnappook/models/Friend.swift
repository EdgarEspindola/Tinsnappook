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
    var photoURL: String?
    var genero: Bool
    var dateBirth: String
    
    init(uid: String?, userName: String, genero: Bool, dateBirth: String) {
        self.uid = uid
        self.userName = userName
        self.genero = genero
        self.dateBirth = dateBirth
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["userName"] as? String,
            let genero = value["genero"] as? Bool,
            let dateBirth = value["dateBirth"] as? String else {
                return nil
        }
        
        self.uid = snapshot.key
        self.userName = userName
        self.genero = genero
        self.dateBirth = dateBirth
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "genero": genero,
            "dateBirth": dateBirth
        ]
    }
}
