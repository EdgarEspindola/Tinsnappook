//
//  AlertControllerHelper.swift
//  Tinsnappook
//
//  Created by Usuario on 07/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit

class AlertControllerHelper: NSObject {
    
    func showAlertWithDefaultAction(title: String, message: String, controller: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        controller.present(ac, animated: true)
        return
    }
}
