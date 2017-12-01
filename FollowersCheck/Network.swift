//
//  Network.swift
//  FollowersCheck
//
//  Created by Maxim on 10/25/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import Alamofire

func logout(){
    Alamofire.request(InstagramAPI.INSTAGRAM_LOGOUT)
}

func getFollowers() {
    Alamofire.request(String(format: "%@self/followed-by?access_token=%@", arguments: [InstagramAPI.INSTAGRAM_APIURl,InstagramAPI.access_token]), method: .get).responseJSON{ response in
        print(response)
    }
}
/*
func createSet(json: DataResponse<Any>) -> Set<User>{
    var set = Set<User>()
    if let result = json.result.value as? [String: AnyObject] {
        let jsonList = result["data"] as! [AnyObject]
        for item in jsonList {
            var user = User()
            let buf = item as! [String: AnyObject]
            user.username = buf["username"] as! String
            set.insert(user)
        }
    }
    return set
}*/
