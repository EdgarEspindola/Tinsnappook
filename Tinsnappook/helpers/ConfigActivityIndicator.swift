//
//  ConfigActivityIndicator.swift
//  Tinsnappook
//
//  Created by Usuario on 07/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit
import Foundation

class ConfigActivityIndicator: NSObject {
    var activityIndicator: UIActivityIndicatorView!
    
    private func configureFor(view: UIView) {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge        
        view.addSubview(activityIndicator)
        return
    }
    
    func start(view: UIView) {
        configureFor(view: view)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        return
    }
    
    func stop() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        return
    }
}

