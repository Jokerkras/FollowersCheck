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
    @IBOutlet var myView: UIView!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var labelFollows: UILabel!
    @IBOutlet weak var labelFollowedBy: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var arrayOfCells = [cellData]()
    let userTool = FollowerDownloader()
    var odd = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    var notodd = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
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
        self .performSegue(withIdentifier: "segueLogout", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InstagramAPI.INSTAGRAM_ACCESS_TOKEN == ""{
            out()
        }
        else {
            view.addSubview(activityIndicator)
            getParams(block: {(name: String, id: String, fc: String, fbc: String, pi: String) in
                InstagramAPI.INSTAGRAM_PROFILE_IMAGE = pi
                InstagramAPI.INSTAGRAM_USERNAME = name
                self.labelNickname.text = name
                InstagramAPI.INSTAGRAM_FOLLOWEDBY = fbc
                self.labelFollowedBy.text = InstagramAPI.INSTAGRAM_FOLLOWEDBY
                InstagramAPI.INSTAGRAM_FOLLOWS = fc
                self.labelFollows.text = InstagramAPI.INSTAGRAM_FOLLOWS
                InstagramAPI.INSTAGRAM_USER_ID = id
                self.requestEnded()
                self.buttonRefreshPressed(self)
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicator.center = self.profileImage.center
        self.activityIndicator.color = UIColor.black
        
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
        profileImage.layer.borderWidth = 1.0
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
            destination.navTitle.title = arrayOfCells[i].nickname
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let fol = Set<User>(self.followers)
        let foldb = Set<User>(self.followedBy)
        let lfoldb = Set<User>(self.lastFollowedBy)
        
        i = indexPath.row
        if i == 0 {
            setToSegue = foldb.subtracting(lfoldb)
        } else if i == 1 {
            setToSegue = lfoldb.subtracting(foldb)
        } else if i == 2 {
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
                           countfollowers: foldb.subtracting(lfoldb).count)
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
        self.profileImage.image = #imageLiteral(resourceName: "user")
        self.activityIndicator.startAnimating()
        self.labelFollows.text = "..."
        self.labelFollowedBy.text = "..."
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
            
            userTool.getFollowers({(usrs: [User]) in
                self.followers = [User](usrs)
                FollowersCaching.setFollowersToCache(users: self.followers)
                self.tableView1.reloadData()
                self.requestEnded()
            })
            
            userTool.getFollowedByYou({(usrs: [User]) in
                self.followedBy = [User](usrs)
                FollowersCaching.setFollowedByToCache(users: self.followedBy)
                self.tableView1.reloadData()
                self.requestEnded()
            })
            
            getPicture(url: InstagramAPI.INSTAGRAM_PROFILE_IMAGE, block: {(data: Data) in
                self.profileImage.image = UIImage(data: data)
                self.requestEnded()
            })
            unFollow()
            lastFollowers = FollowersCaching.getLastFollowers()
            lastFollowedBy = FollowersCaching.getLastFollowedBy()
        }
    }
}

