//
//  ProfileTableViewCell.swift
//  FollowersCheck
//
//  Created by xcode on 25.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func configure(user: User) {
        self.nickname.text = user.username
        self.profileImage.image = #imageLiteral(resourceName: "user")
        getPicture(url: user.profileImage, block: {(data: Data) in
            self.profileImage.image = UIImage(data: data)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 194/255, green: 239/255, blue: 249/255, alpha: 1.0)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        
        followButton.backgroundColor = UIColor(red: 150/255, green: 227/255, blue: 255/255, alpha: 1.0)
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = followButton.frame.size.width / 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
