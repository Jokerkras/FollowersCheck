//
//  InstagramAPI.swift
//  FollowersCheck
//
//  Created by Maxim on 10/25/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

struct InstagramAPI{
    static var access_token = ""
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID = "35e1abbf8b474e1593e7b8c2f72f9cdd"
    static let INSTAGRAM_CLIENTSERCRET = "78711e7a35af45d0937397cb6bc50d56"
    static let INSTAGRAM_REDIRECT_URI = "http://localhost"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "basic+follower_list+relationships"
    static var INSTAGRAM_USER = 0
}
