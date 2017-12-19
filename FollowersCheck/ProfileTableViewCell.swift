//
//  ProfileTableViewCell.swift
//  FollowersCheck
//
//  Created by xcode on 25.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func configure(user: User) {
        self.nickname.text = user.username
        self.profileImage.image = #imageLiteral(resourceName: "user")
        getPicture(url: user.profileImage, block: {(data: Data?, er: Error?) in
            if er == nil {
                self.profileImage.image = UIImage(data: data!)
            }
        })
    }
    
    @IBOutlet weak var forR: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 244/255, green: 255/255, blue: 255/255, alpha: 1.0)
        profileImage.layer.cornerRadius = profileImage.layer.frame.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

