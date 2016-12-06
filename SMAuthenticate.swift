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
    
    func authenticateUser(userDetailsToSave: NSDictionary, tokenCallback: @escaping (_ token: String?, _ error: NSError?) -> ()) {
            let url = URL(string: "\(SMURLManager.AuthBase.base)")
            var request = URLRequest(url: url! as URL)
            let body = userDetailsToSave
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = jsonBody
            } catch let error as NSError {
                tokenCallback(nil, error)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                data, response, error in
                if error != nil {
                    tokenCallback(nil, error as NSError?)
                } else if data != nil {
                    do {
                        let serializedData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        if let dictionaryData = serializedData as? NSDictionary {
                            let parsedToken = self.parseTokenFromAuth(dataToParse: dictionaryData)
                            if parsedToken != nil {
                                SMTokenManager().saveToken(tokenToSave: parsedToken!)
                            }
                            tokenCallback(self.parseTokenFromAuth(dataToParse: dictionaryData), nil)
                        }
                    } catch let error as NSError {
                        tokenCallback(nil, error)
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
