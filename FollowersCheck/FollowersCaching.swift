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
    static let DISK_PATH  = "MyPreferences"
    static let SEPARATOR  = "|"
    static let FOLLOWERS  = "Followers"
    static let FOLLOWEDBY = "FollowedBy"
    static let USER       = "User"
    static let STATISTIC  = "Statistic"
    
    static let MAX_RECORDS_COUNT = 5;
    static let FORMATTER  = DateFormatter()

    static let diskConfig = DiskConfig(name: DISK_NAME,
                                directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create:true).appendingPathComponent(DISK_PATH),
                                protectionType: .complete)
    
    static let storage = try! Storage(diskConfig: diskConfig)
    
    static func setCurrentUserToCache() {
        var userForCache = Array<String>()
        userForCache.append(InstagramAPI.INSTAGRAM_USER_ID)
        userForCache.append(InstagramAPI.INSTAGRAM_USERNAME)
        try! storage.setObject(userForCache, forKey: USER)
    }
    
    //result[0] - userId, result[1] - userName
    static func getLastUserFromCache() -> Array<String> {
        var lastUser = Array<String>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: USER) {
            try! lastUser = storage.object(ofType: Array<String>.self, forKey: USER)
        }
        
        return lastUser
    }
    
    static func removeLastUserFromCache() {
        if try! storage.existsObject(ofType: Array<String>.self, forKey: USER) {
            try! storage.removeObject(forKey: USER)
        }
    }
    
    static func setAllStatisticToCache() {
        let date = Date()
        let dateStr = FORMATTER.string(from: date)
        
        var dates = Array<String>()
        
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + STATISTIC
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            dates = try! storage.object(ofType: Array<String>.self, forKey: key)
        }
        
        if dates.count >= MAX_RECORDS_COUNT {
            let dateToRemove = dates.removeFirst()
            try! storage.removeObject(forKey: key + SEPARATOR + dateToRemove)
        }
        
        dates.append(dateStr)
        try! storage.setObject(dates, forKey: key)
        
        try! storage.setObject([InstagramAPI.INSTAGRAM_FOLLOWS, InstagramAPI.INSTAGRAM_FOLLOWEDBY], forKey: key + SEPARATOR + dateStr)
    }
    
    static func getAllStatisticFromCache() -> Dictionary<String, Array<String>> {
        var result = Dictionary<String, Array<String>>()
        
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + STATISTIC
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            let dates = try! storage.object(ofType: Array<String>.self, forKey: key)
            var value: Array<String>
            
            for date in dates{
                value = try! storage.object(ofType: Array<String>.self,
                                            forKey: key + SEPARATOR + date)
                result.updateValue(value, forKey: date)
            }
        }
        
        return result
    }
    
    //key : user_id + separator + followers/followed_by
    static private func getUsersFromCache(forKey key: String) -> Dictionary<String, Array<User>> {
        var result = Dictionary<String, Array<User>>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            let dates = try! storage.object(ofType: Array<String>.self, forKey: key)
            var value: Array<User>
            
            for date in dates{
                value = try! storage.object(ofType: Array<User>.self,
                                            forKey: key + SEPARATOR + date)
                result.updateValue(value, forKey: date)
            }
        }
        
        return result
    }

    static func getFollowersFromCache() -> Dictionary<String, Array<User>> {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWERS
        
        return getUsersFromCache(forKey: key)
    }
    
    static func getFollowedByFromCache() -> Dictionary<String, Array<User>> {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWEDBY
        
        return getUsersFromCache(forKey: key)
    }
    
    static private func setUsersToCache(forKey key: String, users: Array<User>) {
        let date = Date()
        let dateStr = FORMATTER.string(from: date)
        
        var dates = Array<String>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            dates = try! storage.object(ofType: Array<String>.self, forKey: key)
        }
        
        if dates.count >= MAX_RECORDS_COUNT {
            let dateToRemove = dates.removeFirst()
            try! storage.removeObject(forKey: key + SEPARATOR + dateToRemove)
        }
        
        dates.append(dateStr)
        try! storage.setObject(dates, forKey: key)
        try! storage.setObject(users, forKey: key + SEPARATOR + dateStr)
    }
    
    static func setFollowersToCache(users: Array<User>) {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWERS
        
        setUsersToCache(forKey: key, users: users)
    }
    
    static func setFollowedByToCache(users: Array<User>) {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWEDBY
        
        setUsersToCache(forKey: key, users: users)
    }
    
    static private func getLastUsers(forKey key: String) -> Array<User> {
        var dates = Array<String>()
        
        if try! storage.existsObject(ofType: Array<String>.self, forKey: key) {
            dates = try! storage.object(ofType: Array<String>.self, forKey: key)
        }
        
        var result = Array<User>()
        
        if dates.count > 0 {
            result = try! storage.object(ofType: Array<User>.self, forKey: key + SEPARATOR + dates.last!)
        }
        
        return result
    }
    
    static func getLastFollowers() -> Array<User> {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWERS
        
        return getLastUsers(forKey: key)
    }
    
    static func getLastFollowedBy() -> Array<User> {
        let key = InstagramAPI.INSTAGRAM_USER_ID + SEPARATOR + FOLLOWEDBY
        
        return getLastUsers(forKey: key)
    }
    
    static func clearCache() {
        try! storage.removeAll()
    }
}
