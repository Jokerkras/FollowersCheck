//
//  FollowerDownloader.swift
//  FollowersCheck
//
//  Created by xcode on 18.11.2017.
//  Copyright © 2017 PMUGroup. All rights reserved.
//
import Alamofire

class FollowerDownloader: FollowersGetProtocol {

    func getFollowers(_ block: @escaping ([User]) -> Void) {
        
        Alamofire.request(String(format: "%@?query_id=%@&id=%@&first=%@", arguments: [InstagramAPI.INSTAGRAM_GRAPHQL,InstagramAPI.INSTAGRAM_FOLLOWS_QUERY, InstagramAPI.INSTAGRAM_USER_ID,InstagramAPI.INSTAGRAM_FOLLOWS]), method: .get).responseJSON{ response in
                var Users:[User] = []
                if let responseJSON = response.result.value as? [String: AnyObject] {
                    let data = responseJSON["data"] as! [String: AnyObject]
                    let user = data["user"] as! [String: AnyObject]
                    let edges = user["edge_follow"] as! [String: AnyObject]
                    let nodes = edges["edges"] as! [AnyObject]
                    for edge in nodes {
                        let edgep = edge as! [String: AnyObject]
                        let node = edgep["node"] as! [String: AnyObject]
                        let nick = node["username"] as! String
                        let image = node["profile_pic_url"] as! String
                        Users.append(User(username: nick, profileImage: image))
                    }
                }
                block(Users)
        }
    }
    
    func getFollowedByYou(_ block: @escaping ([User]) -> Void) {
        Alamofire.request(String(format: "%@?query_id=%@&id=%@&first=%@", arguments: [InstagramAPI.INSTAGRAM_GRAPHQL,InstagramAPI.INSTAGRAM_FOLLOWEDBY_QUERY, InstagramAPI.INSTAGRAM_USER_ID,InstagramAPI.INSTAGRAM_FOLLOWEDBY]), method: .get).responseJSON{ response in
            var Users:[User] = []
            if let responseJSON = response.result.value as? [String: AnyObject] {
                let data = responseJSON["data"] as! [String: AnyObject]
                let user = data["user"] as! [String: AnyObject]
                let edges = user["edge_followed_by"] as! [String: AnyObject]
                let nodes = edges["edges"] as! [AnyObject]
                for edge in nodes {
                    let edgep = edge as! [String: AnyObject]
                    let node = edgep["node"] as! [String: AnyObject]
                    let nick = node["username"] as! String
                    let image = node["profile_pic_url"] as! String
                    Users.append(User(username: nick, profileImage: image))
                }
            }
            block(Users)
        }
    }
}
