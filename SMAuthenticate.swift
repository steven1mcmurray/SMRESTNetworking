//
//  Authenticate.swift
//  fillr
//
//  Created by Steven McMurray on 5/8/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//
//  Use this class to authenticate a user. Only 1 method needed, will return a token. SMRESTNetworking utilizes FXKeychain to encrypt and store the token locally

/*
    Sample Usage:
    let auth = Authenticator(serverTokenKey: "token")
    let body = ["emailAddress" : "test@gmail.com"]
 
    auth.authenticateUser(userDetailsToSave: body, tokenCallback: {
        tokenReturned, error in
        Do something with the token if desired, it is persisted already using TokenManager class
    })
*/

import Foundation

class SMAuthenticator: NSObject {
    
/* Authenticates a user. Listen for optional token callback, will print error to console if error.
*/
    let serverTokenKey: String
    
    init(serverTokenKey: String) {
        self.serverTokenKey = serverTokenKey
    }
    
    func authenticateUser(userDetailsToSave: NSDictionary, tokenCallback: (token: String?, error: NSError?) -> ()) {
            let url = NSURL(string: "\(URLManager.AuthBase.base)")
            let request = NSMutableURLRequest(URL: url!)
            let body = userDetailsToSave
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
                request.HTTPBody = jsonBody
            } catch let error as NSError {
                tokenCallback(token: nil, error: error)
                return
            }
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
                data, response, error in
                if error != nil {
                    tokenCallback(token: nil, error: error)
                } else if data != nil {
                    do {
                        let serializedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        if let dictionaryData = serializedData as? NSDictionary {
                            let parsedToken = self.parseTokenFromAuth(dictionaryData)
                            if parsedToken != nil {
                                TokenManager().saveToken(parsedToken)
                            }
                            tokenCallback(token: self.parseTokenFromAuth(dictionaryData), error: nil)
                        }
                    } catch let error as NSError {
                        tokenCallback(token: nil, error: error)
                        return
                    }
                    
                }
            })
            task.resume()
    }

/* Parses a token object. Will return optional token if one is created.
*/
     func parseTokenFromAuth(dataToParse: NSDictionary) -> String? {
        if dataToParse["error"] != nil {
            return nil
        } else {
            if dataToParse[serverTokenKey] != nil {
                return dataToParse[serverTokenKey] as? String
            } else {
                return nil
            }
        }
    }
}