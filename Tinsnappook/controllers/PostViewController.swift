//
//  PostViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 09/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    let postsService = PostsService()
    var configActivityIndicator: ConfigActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configActivityIndicator = ConfigActivityIndicator(view: view)

        print("En viewDidLoad PostViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("En viewDidAppear PostViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("en viewWillAppear PostViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("en viewDidDisappear PostViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("en viewWillDisappear PostViewController")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        let message = textView.text
        let idUser = Auth.auth().currentUser?.uid
        let post = Post(message: message!, userID: idUser!)
        
        configActivityIndicator.start()
        postsService.create(post: post) { [unowned self] (error: Error?) in
            self.configActivityIndicator.stop()
            let alertHelper = AlertControllerHelper()
            
            if let error = error {
                DispatchQueue.main.async {
                    alertHelper.showAlertWithDefaultAction(title: "Opps, ha habido un fallo", message: error.localizedDescription, controller: self)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    alertHelper.showAlertWithDefaultAction(title: "Post publicado", message: "Post publicado de manera correcta", controller: self)
                    self.textView.text = ""
                    return
                }
            }
        } // End create posts
        return
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {        
        print("En deinit de PostViewController")
    }
}
