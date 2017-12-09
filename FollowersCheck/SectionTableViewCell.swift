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
    
    func configure(profileImage: UIImage, nickname: String, countfollowers: Int) {
        self.nickname.text = nickname
        self.profileImage.image = profileImage
        self.countfollowers.text = String(countfollowers)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}
