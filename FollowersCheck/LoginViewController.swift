//
//  LoginViewController.swift
//  FollowersCheck
//
//  Created by Maxim on 10/25/17.
//  Copyright © 2017 PMUGroup. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var isSuccess: Bool = true
    var authURL = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func cancelButtonPressed(_ sender: UIButton)
    {
        self.webView.stopLoading()
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
        
        self .performSegue(withIdentifier: "segueToMainView", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        unSignedRequest()
    }
    
    func unSignedRequest () {
        authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [InstagramAPI.INSTAGRAM_AUTHURL,InstagramAPI.INSTAGRAM_CLIENT_ID,InstagramAPI.INSTAGRAM_REDIRECT_URI, InstagramAPI.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
    }
}

extension LoginViewController: UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request:URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return checkRequestForCallbackURL(request: request)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(InstagramAPI.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            self.webView.stopLoading()
            isSuccess = true
            self .performSegue(withIdentifier: "segueToMainView", sender: self)
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        InstagramAPI.INSTAGRAM_ACCESS_TOKEN = authToken
    }
}
