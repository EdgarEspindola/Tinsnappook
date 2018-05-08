//
//  ConfigRevealView.swift
//  Tinsnappook
//
//  Created by Usuario on 08/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit

class ConfigRevealView: NSObject {
    
    static func addTarget(to button: UIBarButtonItem, in controller: SWRevealViewController, for view: UIView) {
            button.target = controller
            button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(controller.panGestureRecognizer())
    }
}
