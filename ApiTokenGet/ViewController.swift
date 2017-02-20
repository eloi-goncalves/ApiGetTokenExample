//
//  ViewController.swift
//  ApiTokenGet
//
//  Created by Eloi Andre Goncalves on 19/02/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debug: UILabel!
    
    
    //Variables to get Session
    let apiKey = "798920b941701a984a18d3ac6d9a9b0c"
    let getTokenMethod = "authentication/token/new"
    let baseURLSecureString = "https://api.themoviedb.org/3/"
    var requestToken: String?
    
    
    
    
    let getSessionIdMethod = "authentication/session/new"
    var sessionID: String?
    
    
    
    let getUserIdMethod = "account"
    var userID: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {
        if (username.text?.isEmpty)!{
            debug.text = "Username is empty"
        } else if (password.text?.isEmpty)! {
            debug.text = "Passwor is empty"
        } else {
            //create a session hear
           getRequestToken()

            
        }
    }
    
    
    func getRequestToken() {
        
        let urlString = baseURLSecureString + getTokenMethod + "?api_key=" + apiKey
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                DispatchQueue.main.async {
                    self.debug.text = "Login Failed. (Request token.)"
                }
                print("Could not complete the request \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let requestToken = parsedResult["request_token"] as? String {
                    self.requestToken = requestToken
                    // we will soon replace this successful block with a method call
                    
                    DispatchQueue.main.async {
                        self.debug.text = "got request token: \(requestToken)"
                        self.loginWithToken(requestToken: requestToken)
                        self.getSessionID(requestToken: requestToken)
                        
                        //self.completeLogin()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.debug.text = "Login Failed. (Request token.)"
                    }
                    print("Could not find request_token in \(parsedResult)")
                }
            }
        }
        task.resume()
    }
    
    
    func loginWithToken(requestToken: String) {
        let loginMethod = "authentication/token/validate_with_login"
        let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)&username=\(self.username.text!)&password=\(self.password.text!)"
        let urlString = baseURLSecureString + loginMethod + parameters
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                DispatchQueue.main.async {
                    self.debug.text = "Login Failed. (Login Step.)"
                }
                print("Could not complete the request \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let success = parsedResult["success"] as? Bool {
                    // we will soon replace this successful block with a method call
                    
                    DispatchQueue.main.async {
                        self.debug.text = "Login status: \(success)"
                    }
                } else {
                    if let status_code = parsedResult["status_code"] as? Int {
                        DispatchQueue.main.async {
                            let message = parsedResult["status_message"]
                            self.debug.text = "\(status_code): \(message!)"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.debug.text = "Login Failed. (Login Step.)"
                        }
                        print("Could not find success in \(parsedResult)")
                    }
                }
            }
        }
        task.resume()
    }

    
    
    func getSessionID(requestToken: String) {
        let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)"
        let urlString = baseURLSecureString + getSessionIdMethod + parameters
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                DispatchQueue.main.async {
                    self.debug.text = "Login Failed. (Session ID.)"
                }
                print("Could not complete the request \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let sessionID = parsedResult["session_id"] as? String {
                    self.sessionID = sessionID
                    // we will soon replace this successful block with a method call
                    
                    DispatchQueue.main.async {
                        self.debug.text = "Session ID: \(sessionID)"
                        self.getUserID(sessionID: self.sessionID!)
                        self.completeLogin()
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self.debug.text = "Login Failed. (Session ID.)"
                    }
                    print("Could not find session_id in \(parsedResult)")
                }
            }
        }
        task.resume()
    }
    
    
    
    func getUserID(sessionID: String) {
        let urlString = baseURLSecureString + getUserIdMethod + "?api_key=" + apiKey + "&session_id=" + sessionID
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                DispatchQueue.main.async {
                    self.debug.text = "Login Failed. (Get userID.)"
                }
                print("Could not complete the request \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let userID = parsedResult["id"] as? Int {
                    self.userID = userID
                    // we will soon replace this successful block with a method call
                    
                    DispatchQueue.main.async{
                        self.debug.text = "your user id: \(userID)"
                    }
                } else {
                    DispatchQueue.main.async{
                        self.debug.text = "Login Failed. (Get userID.)"
                    }
                    print("Could not find user id in \(parsedResult)")
                }
            }
        }
        task.resume()
    }
    
    
    func completeLogin() {
        let getFavoritesMethod = "account/\(userID)/favorite/movies"
        let urlString = baseURLSecureString + getFavoritesMethod + "?api_key=" + apiKey + "&session_id=" + sessionID!
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                DispatchQueue.main.async{
                    self.debug.text = "Cannot retrieve information about user \(self.userID)."
                }
                print("Could not complete the request \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let results = parsedResult["results"] as? NSArray {
                    DispatchQueue.main.async {
                        let firstFavorite = results.firstObject as? NSDictionary
                        let title = firstFavorite?.value(forKey: "title")
                        self.debug.text = "Title: \(title!)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.debug.text = "Cannot retrieve information about user \(self.userID)."
                    }
                    print("Could not find 'results' in \(parsedResult)")
                }
            }
        }
        task.resume()
    }

}

