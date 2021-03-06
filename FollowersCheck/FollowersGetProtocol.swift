//
//  followersGetProtocol.swift
//  FollowersCheck
//
//  Created by Maxim on 11/10/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

class User: Hashable, Codable{
    var username = ""
    var profileImage = ""
    
    var hashValue: Int {
        return username.hashValue
    }
    
    init( username: String, profileImage: String){
        self.username = username
        self.profileImage = profileImage
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
    }
}

protocol  FollowersGetProtocol {
    func getFollowers(_ block: @escaping ([User], Error?) -> Void)
    func getFollowedByYou(_ block: @escaping ([User], Error?) -> Void)
}
