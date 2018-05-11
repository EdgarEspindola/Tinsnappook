//
//  LastNewsTableViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 07/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
// Email: edgareduardoespindola@gmail.com
//

import UIKit
import Firebase

class LastNewsTableViewController: UITableViewController {
    @IBOutlet var menuBarButtonItem: UIBarButtonItem!
    
    var postsService: PostsService!
    var friendsService: FriendsService!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsService = PostsService()
        friendsService = FriendsService()
        ConfigRevealView.addTarget(to: menuBarButtonItem, in: revealViewController(), for: view)
        
        print("Se ejecuta viewDidLoad LastNewsTableViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("En viewDidAppear LastNewsTableViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().async { [unowned self] in
            self.postsService.allPosts(clearPosts: { [unowned self] in
                self.posts.removeAll()
            }) { [unowned self] (post: Post) in
                self.posts.append(post)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        print("en viewWillAppear LastNewsTableViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("en viewDidDisappear LastNewsTableViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("en viewWillDisappear LastNewsTableViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        let feedback = { (friend: Friend) in
                cell.loadData(friend: friend, post: post)
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            self.friendsService.findBy(post: post, updateCell: feedback)
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        postsService.removeReferences()
        print("En el metodo deinit LastNewsTableViewController")
    }

}
