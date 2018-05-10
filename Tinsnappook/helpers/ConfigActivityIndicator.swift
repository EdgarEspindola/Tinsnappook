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
    let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    private func configureFor() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge        
        view.addSubview(activityIndicator)
        return
    }
    
    func start() {
        configureFor()
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

