//
//  PerfilUsuarioViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 08/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit
import Firebase

class ProfileUser: UIViewController {
    @IBOutlet var menuBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigRevealView.addTarget(to: menuBarButtonItem, in: revealViewController(), for: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
