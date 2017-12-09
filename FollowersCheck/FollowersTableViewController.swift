//
//  FollowersTableViewController.swift
//  FollowersCheck
//
//  Created by xcode on 25.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Foundation
import UIKit



class FollowersTableViewController: UITableViewController {
    
    var users = Set<User>()
    
    @IBOutlet var tableView1: UITableView!
    
    override func viewDidLoad() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
        tableView1.addGestureRecognizer(gesture)
    }
    
    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProfileTableViewCell", owner: self, options: nil)?.first as! ProfileTableViewCell
        cell.configure(user: users[users.index(users.startIndex, offsetBy: indexPath.row)])
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
