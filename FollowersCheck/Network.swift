import Alamofire
import UIKit

func logout(_ block: @escaping () -> Void) {
    Alamofire.request(InstagramAPI.INSTAGRAM_LOGOUT).response{
        response in
        print(response)
        block()
    }
}

func getPicture(block: @escaping (Data) -> Void) {
    Alamofire.request(InstagramAPI.INSTAGRAM_PROFILE_IMAGE, method: .get).response{ response in
        block(response.data!)
    }
}

func getParams(block: @escaping ( String, String, String, String, String) -> Void) {
    Alamofire.request(String(format: "%@self/?access_token=%@", arguments: [InstagramAPI.INSTAGRAM_APIURl,InstagramAPI.INSTAGRAM_ACCESS_TOKEN]), method: .get).responseJSON{ response in
        if let responseJSON = response.result.value as? [String: AnyObject]{
            let data = responseJSON["data"] as! [String: AnyObject]
            let counts = data["counts"] as! [String : Int64]
            block(data["username"] as! String, data["id"] as! String, String(counts["follows"]!),String(counts["followed_by"]!), data["profile_picture"] as! String)
        }
    }
}
