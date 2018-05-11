//
//  PerfilUsuarioViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 08/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class ProfileUser: UIViewController {
    @IBOutlet var menuBarButtonItem: UIBarButtonItem!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var birthDateButton: UIButton!
    
    var configActivityIndicator: ConfigActivityIndicator!
    var friendsService: FriendsService!
    
    var dateBirth: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configActivityIndicator = ConfigActivityIndicator(view: view)
        ConfigRevealView.addTarget(to: menuBarButtonItem, in: revealViewController(), for: view)
        
        print("En viewDidLoad ProfileUserController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let uid = Auth.auth().currentUser?.uid
        
        friendsService = FriendsService()
        configActivityIndicator.start()
        
        DispatchQueue.global().async { [unowned self] in
            self.friendsService.findBy(uid: uid!) { [unowned self] (friend: Friend) in
                self.loadImage(friend: friend)
                self.loadBirthDate(date: friend.dateBirth)
                self.loadGender(gender: friend.genero)
                
                DispatchQueue.main.async { [unowned self] in
                    self.nicknameTextField.text = friend.userName
                    self.configActivityIndicator.stop()
                }
            }
        }
        
        print("En viewDidAppear ProfileUserController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("en viewWillAppear ProfileUserController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("en viewDidDisappear ProfileUserController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("en viewWillDisappear ProfileUserController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// Close the session user
    ///
    /// - Parameter sender: barButtonItem that trigger the action
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        // start signout
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        // end signout
        if let accessView = storyboard?.instantiateViewController(withIdentifier: "accessView") as? AccessViewController {
            navigationController?.show(accessView, sender: nil)
        }
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
        if let nickname = nicknameTextField.text {
            configActivityIndicator.start()
            
            // Start profile change
//            let changeRequest: UserProfileChangeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            
            
        } else {
            AlertControllerHelper().showAlertWithDefaultAction(title: "Nickname vacío", message: "Proporcione un nickname", controller: self)
        }
    }
    
    func loadBirthDate(date: String?) {
        if let birthDate = date {
            birthDateButton.setTitle(birthDate, for: .normal)
        } else {
            birthDateButton.setTitle("Desconocida", for: .normal)
        }
    }
    
    // MARK: Private Methods
    private func loadImage(friend: Friend) {
        if let image = friend.photoURL {
            // MOSTRAR LA FOTO DE PERFIL DEL USUARIO
        } else {
            DispatchQueue.main.async { [unowned self] in
                self.userImageView.image = UIImage(named: "no-friend")
            }
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
            self.userImageView.clipsToBounds = true
        }
    }
    
    private func loadGender(gender: Bool?) {
        if let gender = gender {
            if gender {
                genderSwitch.isOn = true
                genderLabel.text = "Mujer"
            } else {
                genderSwitch.isOn = false
                genderLabel.text = "Hombre"
            }
        } else {
            genderLabel.text = "Desconocido"
        }
    }
    
    // MARK: Unfreeze resources
    deinit {
        print("En deinit de ProfileUserController")
    }    
}
