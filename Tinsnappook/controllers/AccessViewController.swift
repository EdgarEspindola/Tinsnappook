//
//  ViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 07/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
// Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class AccessViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var configActivityIndicator: ConfigActivityIndicator!
    var friendsService: FriendsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        print("En viewDidLoad AccessViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendsService = FriendsService()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configActivityIndicator = ConfigActivityIndicator(view: view)
        
        print("en viewWillAppear AccessViewcontroller")
        return
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("En viewDidAppear AccessViewController")
        
        if let _ = Auth.auth().currentUser {
            print("Relizando segue before....")
            performSegue(withIdentifier: "goMainVC", sender: nil)
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("en viewWillDisappear AccessViewcontroller")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("en viewDidDisappear AccessViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Realiza el procedimiento para el registro de usuarios
    /// a través de usuario y contraseña
    ///
    /// - Parameter sender: button para disparar el registro
    @IBAction func didCreateAccount(_ sender: UIButton) {
        if let email = emailTextField.text, email != "" {
            if let password = passwordTextField.text, password != "" {
                configActivityIndicator.start()
                
                // Start create user
                Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (user: User?, error: Error?) in
                   
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.configActivityIndicator.stop()
                        self.createFriendDefault(user: user!)
                        // Navegar a la pestaña principal
                        self.performSegue(withIdentifier: "goMainVC", sender: nil)
                        return
                    }
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
    
    /// Realiza el procedimiento para loguear a un usuario
    /// a través de usuario y contraseña
    ///
    /// - Parameter sender: button para disparar el login
    @IBAction func didTapEmailLogin(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            configActivityIndicator.start()
            
            // Start headless_email_auth
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (user: User?, error: Error?) in
                
                DispatchQueue.main.async {
                    self.configActivityIndicator.stop()
                    if let error = error {
                        AlertControllerHelper().showAlertWithDefaultAction(title: "Error", message: error.localizedDescription, controller: self)
                        return
                    }
                    
                    self.performSegue(withIdentifier: "goMainVC", sender: nil)
                    return
                }
            }
            
        } else {
            AlertControllerHelper().showAlertWithDefaultAction(title: "Error", message: "Email - Password can't be empty", controller: self)
            return
        }
    }
    
    /// Request change password
    ///
    /// - Parameter sender: UIButton that trigger the action
    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        let ac = UIAlertController(title: "Recovery password", message: "Introduce your email", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Recovery", style: .default, handler: { [unowned self] (action) in
            let textField = ac.textFields![0]
            if let email = textField.text {
                self.configActivityIndicator.start()
                
                // Start reset password
                Auth.auth().sendPasswordReset(withEmail: email, completion: { [unowned self] (error: Error?) in
                    
                    DispatchQueue.main.async {
                        self.configActivityIndicator.stop()
                        
                        if let error = error {
                            AlertControllerHelper().showAlertWithDefaultAction(title: "Error", message: error.localizedDescription, controller: self)
                            return
                        }
                        AlertControllerHelper().showAlertWithDefaultAction(title: "Recovery password", message: "Please, update tu password from the link in your email tray", controller: self)
                        return
                    }
                }) // End reset recovery
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        return
    }
    
    // MARK: - Private methods
    
    /// Crea el nodo friend asociado con el usuario recien creado
    ///
    /// - Parameter user: El usuario que acaba de registrarse
    private func createFriendDefault(user: User) {
        let userName = user.displayName ?? ""
        let friend = Friend(uid: user.uid, userName: userName)
        
        friendsService.create(friend: friend) { (error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    AlertControllerHelper().showAlertWithDefaultAction(title: "Opps, ha habido un fallo", message: error.localizedDescription, controller: self)
                    return
                }
            }
        }        
        return
    }
    
    deinit {
        print("deinit en accessViewController")
        return
    }
}

