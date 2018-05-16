//
//  PostViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 09/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
// Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    var postsService: PostsService!
    var configActivityIndicator: ConfigActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configActivityIndicator = ConfigActivityIndicator(view: view)

        print("En viewDidLoad PostViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postsService = PostsService()
        
        print("en viewWillAppear PostViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("En viewDidAppear PostViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("en viewWillDisappear PostViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("en viewDidDisappear PostViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        //let message = textView.text
        let alertHelper = AlertControllerHelper()
        
        guard let message = textView.text, let imageSelected = imageView.image else {
            alertHelper.showAlertWithDefaultAction(title: "Campos vacios", message: "Uno o mas campos vacíos", controller: self)
            return
        }
        
        let idUser = Auth.auth().currentUser?.uid
        let post = Post(uid: nil, message: message, userID: idUser!)
        
        configActivityIndicator.start()
        
        postsService.create(post: post) { [unowned self] (error: Error?, reference: DatabaseReference?) in
            //self.configActivityIndicator.stop()
            if let error = error {
                self.configActivityIndicator.stop()
                DispatchQueue.main.async {
                    alertHelper.showAlertWithDefaultAction(title: "Opps, ha habido un fallo", message: error.localizedDescription, controller: self)
                    return
                }
            } else {
                // Agregar la imagen del post
                if let reference = reference {
                    let imageData = UIImageJPEGRepresentation(imageSelected, 1)
                    self.postsService.uploadPhoto(uid: reference.key, dataFile: imageData!, { (error) in
                        self.configActivityIndicator.stop()
                        
                        if let error = error {
                            print("Error upload image post: \(error.localizedDescription)")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            alertHelper.showAlertWithDefaultAction(title: "Post publicado", message: "Post publicado de manera correcta", controller: self)
                            self.textView.text = ""
                            self.imageView.image = nil
                            return
                        }
                    })
                }
            }
        } // End create posts
        return
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true)
    }

    deinit {        
        print("En deinit de PostViewController")
    }
}
