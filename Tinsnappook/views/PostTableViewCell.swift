//
//  PostTableViewCell.swift
//  Tinsnappook
//
//  Created by Usuario on 10/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
// Email: edgareduardoespindola@gmail.com
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameUserLabel: UILabel!
    @IBOutlet var creationDatePostLabel: UILabel!
    @IBOutlet var datosPostLabel: UILabel!
    @IBOutlet var imagePostView: UIImageView!
    
    func loadData(friend: Friend, post: Post) {
        userImageView.image = nil
        usernameUserLabel.text = friend.userName
        creationDatePostLabel = nil
        datosPostLabel.text = post.message
        imagePostView.image = nil
    }
}
