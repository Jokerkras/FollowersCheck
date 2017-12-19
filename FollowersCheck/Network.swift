import Alamofire
import UIKit

func logout(_ block: @escaping () -> Void) {
    Alamofire.request(InstagramAPI.INSTAGRAM_LOGOUT).response{
        response in
        InstagramAPI.INSTAGRAM_USER_ID = ""
        InstagramAPI.INSTAGRAM_USERNAME = ""
        InstagramAPI.INSTAGRAM_ACCESS_TOKEN = ""
        FollowersCaching.removeLastUserFromCache()
        block()
    }
}

func getPicture(url: String, block: @escaping (Data?, Error?) -> Void) {
    Alamofire.request(url, method: .get).response{ response in
        if response.error != nil {
            block(nil , response.error)
            return
        }
        block(response.data, nil)
    }
}

func unFollow() {
    Alamofire.request(String(format: "https://www.instagram.com/web/friendships/%@/unfollow/1120232439", arguments: [InstagramAPI.INSTAGRAM_USER_ID])).response { response in
        print(response)
    }
}

func getParams(block: @escaping ( String, String, String, String, String, Error?) -> Void) {
    Alamofire.request(String(format: "%@self/?access_token=%@", arguments: [InstagramAPI.INSTAGRAM_APIURl,InstagramAPI.INSTAGRAM_ACCESS_TOKEN]), method: .get).responseJSON{ response in
        guard response.result.isSuccess else {
            block("","","","","", response.error)
            return
        }
        if let responseJSON = response.result.value as? [String: AnyObject]{
            let data = responseJSON["data"] as! [String: AnyObject]
            let counts = data["counts"] as! [String : Int64]
            block(data["username"] as! String, data["id"] as! String, String(counts["follows"]!),String(counts["followed_by"]!), data["profile_picture"] as! String, nil)
        }
    }
}
