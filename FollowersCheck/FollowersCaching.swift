//
//  FollowersCaching.swift
//  FollowersCheck
//
//  Created by Mark on 25/11/2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Foundation
import Cache

let diskConfig = DiskConfig(name: "Floppy",
                            directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create:true).appendingPathComponent("MyPreferences"),
                            protectionType: .complete)


let storage = try! Storage(diskConfig: diskConfig)

func getFollowersFromCache() -> Dictionary<String, Set<User>> {
    let userId = String(InstagramAPI.INSTAGRAM_USER)
    
    var result = Dictionary<String, Set<User>>()
    
    if try! storage.existsObject(ofType: Array<String>.self, forKey: userId) {
        let dates = try! storage.object(ofType: Array<String>.self, forKey: userId)
        var value: Set<User>
        
        for date in dates{
            value = try! storage.object(ofType: Set<User>.self,
                                        forKey: userId + InstagramAPI.SEPARATOR + date)
            result.updateValue(value, forKey: date)
        }
    }
    
    return result
}

func setFollowersToCache(users: Set<User>) {
    let userId = String(InstagramAPI.INSTAGRAM_USER)
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy";
    let dstr = formatter.string(from: date)
    
    var dates = Array<String>()
    
    if try! storage.existsObject(ofType: Array<String>.self, forKey: userId) {
        dates = try! storage.object(ofType: Array<String>.self, forKey: userId)
    }
    
    
    dates.append(dstr)
    
    try! storage.setObject(dates, forKey: String(InstagramAPI.INSTAGRAM_USER))
    try! storage.setObject(users, forKey: String(InstagramAPI.INSTAGRAM_USER) + InstagramAPI.SEPARATOR + dstr)
}
