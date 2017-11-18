//
//  UserViewCell.swift
//  FollowersCheck
//
//  Created by xcode on 18.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Foundation
import UIKit

class UserViewCell: UITableViewCell {
    

    @IBOutlet weak var nickname: UILabel!
    
    public static let reuseId = "UserViewCell_reuseId"
    
    public func configure( for user: User) {
        nickname.text = user.username
    }
}
