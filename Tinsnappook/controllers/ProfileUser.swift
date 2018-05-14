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

class ProfileUser: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        //configActivityIndicator.start()
        
        DispatchQueue.global().async { [unowned self] in
            self.friendsService.findBy(uid: uid!) { [unowned self] (friend: Friend) in
                self.loadImage(friend: friend)
                
                if self.birthDateButton.currentTitle == "dd/MM/yyyy" {
                   self.loadBirthDate(date: friend.dateBirth)
                }
                
                self.loadGender(gender: friend.genero)
                
                if self.nicknameTextField.text == "" {
                    DispatchQueue.main.async { [unowned self] in
                        self.nicknameTextField.text = friend.userName
                        //self.configActivityIndicator.stop()
                    }
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
        // Unico campo obligatorio
        if let username = nicknameTextField.text {
            let genero = genderSwitch.isOn
            let dateBirth = birthDateButton.currentTitle!
            let uidCurrentUser = Auth.auth().currentUser?.uid
            let friend = Friend(uid: uidCurrentUser, userName: username, genero: genero, dateBirth: dateBirth)
            let profilePhotoData = UIImageJPEGRepresentation(userImageView.image!, 0.8)
            
            configActivityIndicator.start()
            
            friendsService.create(friend: friend) { [unowned self] (error: Error?) in
                if let error = error {
                    self.configActivityIndicator.stop()
                    AlertControllerHelper().showAlertWithDefaultAction(title: "Error", message: error.localizedDescription, controller: self)
                } else {
                    let uid = Auth.auth().currentUser!.uid
                    self.friendsService.uploadPhotoProfile(uid: uid, dataFile: profilePhotoData!, { (error: Error?) in
                        self.configActivityIndicator.stop()
                        
                        if let error = error {
                           AlertControllerHelper().showAlertWithDefaultAction(title: "Error", message: error.localizedDescription, controller: self)
                        } else {
                            AlertControllerHelper().showAlertWithDefaultAction(title: "Actualizacion exitosa", message: "Tus datos fueron actualizados correctamente", controller: self)
                        }
                    })
                }
            }
            
        } else {
            AlertControllerHelper().showAlertWithDefaultAction(title: "Nombre de usuario vacío", message: "Proporcione un nombre de usuario", controller: self)
        }
    }
    
    @IBAction func switchGenderChanged(_ sender: UISwitch) {
        if genderSwitch.isOn {
            genderLabel.text = "Mujer"
        } else {
            genderLabel.text = "Hombre"
        }
    }
    
    func loadBirthDate(date: String?) {
        if let birthDate = date {
            birthDateButton.setTitle(birthDate, for: .normal)
        } else {
            birthDateButton.setTitle("Desconocida", for: .normal)
        }
    }
    
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    private func loadImage(friend: Friend) {
        if let image = friend.photoURL {
            // MOSTRAR LA FOTO DE PERFIL DEL USUARIO
        } else if userImageView.image == nil {
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
