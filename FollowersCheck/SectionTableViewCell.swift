//
//  SectionTableViewCell.swift
//  FollowersCheck
//
//  Created by xcode on 22.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var countfollowers: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var circle: UIView!
    
    func configure(profileImage: UIImage, nickname: String, countfollowers: Int) {
        self.nickname.text = nickname
        self.profileImage.image = profileImage
        self.countfollowers.text = String(countfollowers)
        self.circle.layer.cornerRadius = self.circle.layer.frame.width / 2
       // self.circle.layer.cornerRadius = self.myView.layer.frame.width * 0.12 / 0.8 / 2
    }
}
