//
//  FollowersCaching.swift
//  FollowersCheck
//
//  Created by Mark on 25/11/2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Foundation
import Cache

class FollowersCaching {
    
    static let DISK_NAME  = "Floppy"
    static let DiskPath   = "MyPreferences"
    static let Separator  = "|"
    static let Followers  = "Followers"
    static let FollowedBy = "FollowedBy"
    static let DateFormat = "dd.MM.yyyy"
    static let MaxRecords = 5;
    
    static var userId = String(InstagramAPI.INSTAGRAM_USER)

    static let diskConfig = DiskConfig(name: DISK_NAME,
                                directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create:true).appendingPathComponent(DiskPath),
                                protectionType: .complete)
    
    static let storage = try! Storage(diskConfig: diskConfig)
    
    //key : user_id + followers/followed_by
    static private func getUsersFromCache(forKey key:String) -> Dictionary<String, Set<User>> {
        var result = Dictionary<String,Set<User>>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            let dates = try! storage.object(ofType: Array<String>.self, forKey: key)
            var value: Set<User>
            
            for date in dates{
                value = try! storage.object(ofType: Set<User>.self,
                                            forKey: key + Separator + date)
                result.updateValue(value, forKey: date)
            }
        }
        
        return result
    }

    static func getFollowersFromCache() -> Dictionary<String, Set<User>> {
        let key = userId + Separator + Followers
        
        return getUsersFromCache(forKey: key)
    }
    
    static func getFollowedByFromCache() -> Dictionary<String, Set<User>> {
        let key = userId + Separator + FollowedBy
        
        return getUsersFromCache(forKey: key)
    }
    
    static private func setUsersToCache(forKey key: String, users: Set<User>) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat
        let dateStr = formatter.string(from: date)
        
        var dates = Array<String>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: userId) {
            dates = try! storage.object(ofType: Array<String>.self, forKey: userId)
        }
        
        if dates.count >= MaxRecords {
            let dateToRemove = dates.removeFirst()
            try! storage.removeObject(forKey: key + Separator + dateToRemove)
        }
        
        dates.append(dateStr)
        try! storage.setObject(dates, forKey: key)
        try! storage.setObject(users, forKey: key + Separator + dateStr)
    }

    static func setFollowersToCache(users: Set<User>) {
        let key = userId + Followers
        
        setUsersToCache(forKey: key, users: users)
    }
    
    static func setFollowedByToCache(users: Set<User>) {
        let key = userId + FollowedBy
        
        setUsersToCache(forKey: key, users: users)
    }
}
