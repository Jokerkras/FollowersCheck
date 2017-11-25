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
    
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    var odd = UIColor(red: 204/255, green: 235/255, blue: 197/255, alpha: 0.8)
    var notodd = UIColor(red: 123/255, green: 204/255, blue: 196/255, alpha: 0.6)
    
    override func viewDidLoad(){
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        arrayOfCells = [cellData(cell:1, nickname: "Подписки1", countFollowers: 10, profileImage: #imageLiteral(resourceName: "logout")),
                        cellData(cell:2, nickname: "Подписки2", countFollowers: 120, profileImage: #imageLiteral(resourceName: "refresh")),
                        cellData(cell:3, nickname: "Подписки3", countFollowers: 130, profileImage: #imageLiteral(resourceName: "logout")),
                        cellData(cell:4, nickname: "Подписки4", countFollowers: 140, profileImage: #imageLiteral(resourceName: "refresh"))]
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCells[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.nickname.text = arrayOfCells[indexPath.row].nickname
            cell.backgroundColor = notodd
            cell.countfollowers.text = String(arrayOfCells[indexPath.row].countFollowers)
            cell.profileImage.image = arrayOfCells[indexPath.row].profileImage
            return cell
        }else if arrayOfCells[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.nickname.text = arrayOfCells[indexPath.row].nickname
            cell.backgroundColor = odd
            cell.countfollowers.text = String(arrayOfCells[indexPath.row].countFollowers)
            cell.profileImage.image = arrayOfCells[indexPath.row].profileImage
            return cell
        }else if arrayOfCells[indexPath.row].cell == 3 {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.nickname.text = arrayOfCells[indexPath.row].nickname
            cell.backgroundColor = notodd
            cell.countfollowers.text = String(arrayOfCells[indexPath.row].countFollowers)
            cell.profileImage.image = arrayOfCells[indexPath.row].profileImage
            return cell
        }else {
            let cell = Bundle.main.loadNibNamed("SectionTableViewCell", owner: self, options: nil)?.first as! SectionTableViewCell
            cell.nickname.text = arrayOfCells[indexPath.row].nickname
            cell.backgroundColor = odd
            cell.countfollowers.text = String(arrayOfCells[indexPath.row].countFollowers)
            cell.profileImage.image = arrayOfCells[indexPath.row].profileImage
            return cell
        }
    }
}
