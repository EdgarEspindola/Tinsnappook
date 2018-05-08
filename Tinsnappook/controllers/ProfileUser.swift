//
//  PerfilUsuarioViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 08/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//

import UIKit

class ProfileUser: UIViewController {
    @IBOutlet var menuBarButtonItem: UIBarButtonItem!
    @IBOutlet var logoutBarButtonItem: UIBarButtonItem!
    
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

}
