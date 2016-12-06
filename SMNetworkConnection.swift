//
//  NetworkConnection.swift
//  fillr
//
//  Created by Steven McMurray on 5/8/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//
// SMNetworkConnection is the main point of interaction for apps featuring SMRESTNetworking.

/*
    SMNetworkConnection was made to significantly decrease the code written to get up and going with a standard RESTful backend that returns JSON data. 
*/


/*
    Sample Usage:
    let url = NSURL(string: SMURLManager.APIBase)!
    let body = ["foo" : "bar"]
    SMNetworkConnection().makeAuthenticatedRequest(requestMethod: RequestMethod.POST, requestURL: url, bodyDictionary: body, returnedJSON: {
            jsonArray in 
            Handle your JSON data here
        }
*/

import Foundation

class SMNetworkConnection {
    
    let authorizationHeaderField = "authorization"
    
    func makeAuthenticatedRequest(requestMethod: RequestMethod, requestURL: NSURL, bodyDictionary: NSDictionary?, returnedJSON: (NSArray?) -> ()) {
        
        let request = NSMutableURLRequest(URL: requestURL)
        if requestMethod != RequestMethod.GET {
            request.HTTPMethod = requestMethod.methodType
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = bodyDictionary
            do {
                if bodyDictionary != nil {
                    let jsonBody = try NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions.PrettyPrinted)
                    request.HTTPBody = jsonBody
                }
            } catch let error as NSError {
                print("Error serializing JSON:", error)
                return
            }
        }
        if SMTokenManager().getToken() != nil {
            request.setValue(TokenManager().getToken(), forHTTPHeaderField: self.authorizationHeaderField)
        } else {
            print("Error, no token for current user, must authenticate first.")
            return
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if error != nil {
                print("Error in request: ", error)
                returnedJSON(nil)
            } else if data != nil {
                let jsonData = self.handleJSONData(data!)
                returnedJSON(jsonData)
            }
        })
        task.resume()
    }
    
    func handleJSONData(dataToSerialize: NSData) -> NSArray? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(dataToSerialize, options: NSJSONReadingOptions.AllowFragments)
            if let jsonArray = json as? NSArray {
                return jsonArray
            } else if let jsonDictionary = json as? NSDictionary {
                let arrayedDictionary: [NSDictionary] = [jsonDictionary]
                return arrayedDictionary
            } else {
                return nil
            }
            //TODO: Call order parser here and return.
            print("Returned JSON is", json)
        } catch {
            return nil
            print("Couldn't serialize JSON")
        }
    }
}