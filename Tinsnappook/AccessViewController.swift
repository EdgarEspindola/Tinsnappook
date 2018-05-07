//
//  ViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 07/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit
import Firebase

class AccessViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var configActivityIndicator: ConfigActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configActivityIndicator = ConfigActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didCreateAccount(_ sender: UIButton) {
        if let email = emailTextField.text, email != "" {
            if let password = passwordTextField.text, password != "" {
                configActivityIndicator.start(view: view)
                
                // Start create user
                Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (user: User?, error: Error?) in
                    
                    self.configActivityIndicator.stop()
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    // Navegar a la pestaña principal
                    self.performSegue(withIdentifier: "goMainVC", sender: nil)
                }
                
            } else {
                AlertControllerHelper().showAlertWithDefaultAction(title: "Password empty", message: "Introduce a password valid", controller: self)
                return
            }
            
        } else {
            AlertControllerHelper().showAlertWithDefaultAction(title: "Email empty", message: "Introduce a email valid", controller: self)
            return
        }        
    }
}

