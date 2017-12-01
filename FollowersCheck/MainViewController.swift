//
//  MainViewController.swift
//  FollowersCheck
//
//  Created by xcode on 18.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Foundation
import UIKit

struct cellData{
    let cell: Int!
    let nickname: String!
    let countFollowers: Int!
    let profileImage: UIImage!
}



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var arrayOfCells = [cellData]()
    let userTool = FollowersMock()

    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var odd = UIColor(red: 194/255, green: 239/255, blue: 249/255, alpha: 1.0)
    var notodd = UIColor(red: 227/255, green: 247/255, blue: 252/255, alpha: 1.0)
    var followers =  Set<User>()
    var followedBy =  Set<User>()
    
    var setToSegue = Set<User>()
    
    @IBAction func buttonLogoutPressed(_ sender: Any){
        logout()
        
        self .performSegue(withIdentifier: "segueLogout", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
        
        userTool.getFollowers({(usrs: [User]) in
            for us in usrs{
                followers.insert(us)
            }
        })
        userTool.getFollowedByYou({(usrs: [User]) in
            for us in usrs{
                followedBy.insert(us)
            }
        })
    }
    
    override func viewDidLoad(){
        
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.backgroundColor = UIColor(red: 130/255, green: 227/255, blue: 245/255, alpha: 1.0)
        
        arrayOfCells = [cellData(cell:1, nickname: "Подписались", countFollowers: 10, profileImage: #imageLiteral(resourceName: "plus")),
                        cellData(cell:2, nickname: "Отписались", countFollowers: 120, profileImage: #imageLiteral(resourceName: "cancel")),
                        cellData(cell:3, nickname: "Игнорируете Вы", countFollowers: 130, profileImage: #imageLiteral(resourceName: "happy")),
                        cellData(cell:4, nickname: "Игнорируют Вас", countFollowers: 140, profileImage: #imageLiteral(resourceName: "sad"))]
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCells.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? FollowersTableViewController {
            destination.users = setToSegue
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1 {
            setToSegue = followers
        } else if indexPath.row == 2 {
            setToSegue = followedBy
        } else if indexPath.row == 3 {
            setToSegue = followers.subtracting(followedBy)
        } else {
            setToSegue = followedBy.subtracting(followers)
        }
        self .performSegue(withIdentifier: "showFollowers", sender: self)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCells[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: arrayOfCells[indexPath.row].countFollowers)
            cell.backgroundColor = notodd
            return cell
        }else if arrayOfCells[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: arrayOfCells[indexPath.row].countFollowers)
            cell.backgroundColor = odd
            return cell
        }else if arrayOfCells[indexPath.row].cell == 3 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: followers.subtracting(followedBy).count)
            cell.backgroundColor = notodd
            return cell
        }else {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: followedBy.subtracting(followers).count)
            cell.backgroundColor = odd
            return cell
        }
    }
}
