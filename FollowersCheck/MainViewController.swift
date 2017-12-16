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



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var arrayOfCells = [cellData]()
    let userTool = FollowerDownloader()
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var labelFollows: UILabel!
    @IBOutlet weak var labelFollowedBy: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var alert = UIAlertController(title: "Ошибка", message: "Не удалось обновить списки", preferredStyle: UIAlertControllerStyle.alert)

    var odd = UIColor(red: 244/255, green: 255/255, blue: 255/255, alpha: 1.0)
    var notodd = UIColor(red: 179/255, green: 218/255, blue: 242/255, alpha: 1.0)
    var followers =  [User]()
    var followedBy =  [User]()
    var lastFollowers =  [User]()
    var lastFollowedBy =  [User]()
    var i = 1
    
    var setToSegue = Set<User>()
    
    @IBAction func buttonLogoutPressed(_ sender: Any){
        logout(out)
    }
    
    func out() {
        FollowersCaching.removeLastUserFromCache()
        self .performSegue(withIdentifier: "segueLogout", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = FollowersCaching.getLastUserFromCache()
        if InstagramAPI.INSTAGRAM_ACCESS_TOKEN != "" && InstagramAPI.INSTAGRAM_USERNAME == "" {
            getParams(block: {(name: String, id: String, fc: String, fbc: String, pi: String, er: Error?) in
                if er == nil {
                    InstagramAPI.INSTAGRAM_PROFILE_IMAGE = pi
                    InstagramAPI.INSTAGRAM_USERNAME = name
                    self.labelNickname.text = name
                    InstagramAPI.INSTAGRAM_FOLLOWEDBY = fbc
                    self.labelFollowedBy.text = InstagramAPI.INSTAGRAM_FOLLOWEDBY
                    InstagramAPI.INSTAGRAM_FOLLOWS = fc
                    self.labelFollows.text = InstagramAPI.INSTAGRAM_FOLLOWS
                    InstagramAPI.INSTAGRAM_USER_ID = id
                }
                self.buttonRefreshPressed(self)
            })
        } else {
            if user.count == 0 {
                out()
            }
            else {
                alert = UIAlertController(title: "Ошибка", message: "Не удалось обновить списки", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                self.activityIndicator.hidesWhenStopped = true
                view.addSubview(activityIndicator)
                InstagramAPI.INSTAGRAM_USER_ID = user[0]
                InstagramAPI.INSTAGRAM_USERNAME = user[1]
                InstagramAPI.INSTAGRAM_PROFILE_IMAGE = user[2]
                
                followers = FollowersCaching.getLastFollowers()
                followedBy = FollowersCaching.getLastFollowedBy()
                
                self.labelNickname.text = user[1]
                InstagramAPI.INSTAGRAM_FOLLOWEDBY = String(followedBy.count)
                self.labelFollowedBy.text = String(followedBy.count)
                InstagramAPI.INSTAGRAM_FOLLOWS = String(followers.count)
                self.labelFollows.text = String(followers.count)
            }
        }
    }
    
    public var currentOngoingEventCount = 3
    public var currentFinishedEventCount = 0
    public var goodEnd = true
    func requestEnded() {
        currentFinishedEventCount += 1
        if currentFinishedEventCount == currentOngoingEventCount {
            activityIndicator.stopAnimating()
            if !self.goodEnd {
                self.present(alert, animated: true, completion: nil)
            } else {
                lastFollowers = FollowersCaching.getLastFollowers()
                lastFollowedBy = FollowersCaching.getLastFollowedBy()
            }
            self.goodEnd = true
            self.tableView1.allowsSelection = true
        }
        currentOngoingEventCount = 3
        FollowersCaching.setCurrentUserToCache()
    }
    
    override func viewDidLoad(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        arrayOfCells = [cellData(cell:1, nickname: "Подписались", countFollowers: 10, profileImage: #imageLiteral(resourceName: "plus")),
                        cellData(cell:2, nickname: "Отписались", countFollowers: 120, profileImage: #imageLiteral(resourceName: "cancel")),
                        cellData(cell:3, nickname: "Игнорируете Вы", countFollowers: 130, profileImage: #imageLiteral(resourceName: "happy")),
                        cellData(cell:4, nickname: "Игнорируют Вас", countFollowers: 140, profileImage: #imageLiteral(resourceName: "sad"))]
        
        profileImage.layer.cornerRadius = myView.layer.frame.width * 0.4 / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.black.cgColor
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
        let lfoldb = Set<User>(self.lastFollowedBy)
        
        if indexPath.row == 0 {
            setToSegue = foldb.subtracting(lfoldb)
        } else if indexPath.row == 1 {
            setToSegue = lfoldb.subtracting(foldb)
        } else if indexPath.row == 2 {
            setToSegue = foldb.subtracting(fol)
        } else {
            setToSegue = fol.subtracting(foldb)
        }
        self .performSegue(withIdentifier: "showFollowers", sender: self)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fol = Set<User>(self.followers)
        let foldb = Set<User>(self.followedBy)
        let lfoldb = Set<User>(self.lastFollowedBy)
        
        if arrayOfCells[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: foldb.subtracting(lfoldb).count == foldb.count ? 0 : foldb.subtracting(lfoldb).count)
            cell.backgroundColor = notodd
            return cell
        }else if arrayOfCells[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: lfoldb.subtracting(foldb).count)
            cell.backgroundColor = odd
            return cell
        }else if arrayOfCells[indexPath.row].cell == 3 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: foldb.subtracting(fol).count)
            cell.backgroundColor = notodd
            return cell
        }else {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.configure(profileImage: arrayOfCells[indexPath.row].profileImage,
                           nickname: arrayOfCells[indexPath.row].nickname,
                           countfollowers: fol.subtracting(foldb).count)
            cell.backgroundColor = odd
            return cell
        }
    }
    
    
    @IBAction func buttonRefreshPressed(_ sender: Any) {
        self.currentFinishedEventCount = 0
        self.activityIndicator.startAnimating()
        self.tableView1.allowsSelection = false
        if InstagramAPI.INSTAGRAM_ACCESS_TOKEN != "" {
            currentOngoingEventCount = 4
            getParams(block: {(name: String, id: String, fc: String, fbc: String, pi: String, er: Error?) in
                    if er == nil {
                        InstagramAPI.INSTAGRAM_PROFILE_IMAGE = pi
                        InstagramAPI.INSTAGRAM_USERNAME = name
                        self.labelNickname.text = name
                        InstagramAPI.INSTAGRAM_FOLLOWEDBY = fbc
                        self.labelFollowedBy.text = fbc
                        InstagramAPI.INSTAGRAM_FOLLOWS = fc
                        self.labelFollows.text = fc
                        InstagramAPI.INSTAGRAM_USER_ID = id
                    } else {
                        self.goodEnd = false
                    }
                    self.requestEnded()
            })
        }
        getPicture(url: InstagramAPI.INSTAGRAM_PROFILE_IMAGE, block: {(data: Data?, er: Error?) in
            if er == nil {
                self.profileImage.image = UIImage(data: data!)
            } else {
                self.goodEnd = false
            }
            self.requestEnded()
        })
        
        userTool.getFollowers({(usrs: [User], er: Error?) in
            if er == nil {
                self.followers = [User](usrs)
                FollowersCaching.setFollowersToCache(users: self.followers)
                self.tableView1.reloadData()
            } else {
                self.goodEnd = false
            }
            self.requestEnded()
        })
        
        userTool.getFollowedByYou({(usrs: [User], er: Error?) in
            if er == nil {
                self.followedBy = [User](usrs)
                FollowersCaching.setFollowedByToCache(users: self.followedBy)
                self.tableView1.reloadData()
            } else {
                self.goodEnd = false
            }
            self.requestEnded()
        })
    }
}

