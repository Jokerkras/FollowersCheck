//
//  FollowerMock.swift
//  FollowersCheck
//
//  Created by Maxim on 11/10/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//
import Foundation

class FollowersMock: followersGetProtocol{
    
    
    static func getFollowers() -> Set<User> {
        var followersSet = Set<User>()
        for _ in 1...70{
            followersSet.insert(User(username:String(arc4random_uniform(100))))
        }
        return followersSet
    }
    
    static func getFollowedByYou() -> Set<User> {
        var followedBySet = Set<User>()
        for _ in 1...70{
            followedBySet.insert(User(username:String(arc4random_uniform(100))))
        }
        return followedBySet
    }
    
    
}
