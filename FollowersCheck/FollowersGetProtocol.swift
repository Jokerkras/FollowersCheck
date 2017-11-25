//
//  followersGetProtocol.swift
//  FollowersCheck
//
//  Created by Maxim on 11/10/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

class User: Hashable{
    var username = ""
    
    var hashValue: Int {
        return username.hashValue
    }
    
    init( username: String){
        self.username = username
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
    }
}

protocol  FollowersGetProtocol {
    static func getFollowers(_ block: ([String]) -> Void)
    static func getFollowedByYou(_ block: ([String]) -> Void)
}
