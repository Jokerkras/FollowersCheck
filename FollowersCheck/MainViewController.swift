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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var arrayOfCells = [cellData]()
    let userTool = FollowerDownloader()

    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var labelFollows: UILabel!
    @IBOutlet weak var labelFollowedBy: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var odd = UIColor(red: 194/255, green: 239/255, blue: 249/255, alpha: 1.0)
    var notodd = UIColor(red: 227/255, green: 247/255, blue: 252/255, alpha: 1.0)
    var followers =  [User]()
    var followedBy =  [User]()
    
    var setToSegue = Set<User>()
    
    @IBAction func buttonLogoutPressed(_ sender: Any){
        logout(out)
    }
    
    func out() {
        self .performSegue(withIdentifier: "segueLogout", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        getParams(block: {(name: String, id: String, fc: String, fbc: String, pi: String) in
            InstagramAPI.INSTAGRAM_PROFILE_IMAGE = pi
            InstagramAPI.INSTAGRAM_USERNAME = name
            self.labelNickname.text = name
            InstagramAPI.INSTAGRAM_FOLLOWEDBY = fbc
            self.labelFollowedBy.text = fbc
            InstagramAPI.INSTAGRAM_FOLLOWS = fc
            self.labelFollows.text = fc
            InstagramAPI.INSTAGRAM_USER_ID = id
            self.requestEnded()
            self.buttonRefreshPressed(self)
        })
    }
    
    public var currentOngoingEventCount = 4
    public var currentFinishedEventCount = 0
    func requestEnded() {
        currentFinishedEventCount += 1
        if currentFinishedEventCount == currentOngoingEventCount {
            activityIndicator.stopAnimating()
            self.tableView1.allowsSelection = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        self.activityIndicator.startAnimating()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView1.bounds.height / 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCells.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? FollowersTableViewController {
            destination.users = self.setToSegue
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let fol = Set<User>(self.followers)
        let foldb = Set<User>(self.followedBy)
        
        if indexPath.row == 0 {
            setToSegue = fol
        } else if indexPath.row == 1 {
            setToSegue = foldb
        } else if indexPath.row == 2 {
            setToSegue = foldb.subtracting(fol)
        } else {
            setToSegue = fol.subtracting(foldb)
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
                           countfollowers: 4)
            cell.backgroundColor = notodd
            return cell
        }else {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: 5)
            cell.backgroundColor = odd
            return cell
        }
    }

    
    @IBAction func buttonRefreshPressed(_ sender: Any) {
        self.currentFinishedEventCount = 0
        self.activityIndicator.startAnimating()
        self.tableView1.allowsSelection = false
        DispatchQueue.global().sync{
            getParams(block: {(name: String, id: String, fc: String, fbc: String, pi: String) in
                InstagramAPI.INSTAGRAM_PROFILE_IMAGE = pi
                InstagramAPI.INSTAGRAM_USERNAME = name
                self.labelNickname.text = name
                InstagramAPI.INSTAGRAM_FOLLOWEDBY = fbc
                self.labelFollowedBy.text = fbc
                InstagramAPI.INSTAGRAM_FOLLOWS = fc
                self.labelFollows.text = fc
                InstagramAPI.INSTAGRAM_USER_ID = id
                self.requestEnded()
            })

            getPicture(url: InstagramAPI.INSTAGRAM_PROFILE_IMAGE, block: {(data: Data) in
                self.profileImage.image = UIImage(data: data)
                self.requestEnded()
            })

            userTool.getFollowers({(usrs: [User]) in
                self.followers = [User](usrs)
                self.requestEnded()
            })

            userTool.getFollowedByYou({(usrs: [User]) in
                self.followedBy = [User](usrs)
                self.requestEnded()
            })
        }
    }
}
