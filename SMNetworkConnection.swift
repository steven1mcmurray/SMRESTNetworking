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
        })
*/

import Foundation

class SMNetworkConnection {
    
    let authorizationHeaderField = "authorization"
    
    func makeAuthenticatedRequest(requestMethod: RequestMethod, requestURL: URL, bodyDictionary: NSDictionary?, returnedJSON: @escaping (NSArray?) -> ()) {
        
        var request = URLRequest(url: requestURL)
        if requestMethod != RequestMethod.GET {
            request.httpMethod = requestMethod.methodType
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = bodyDictionary
            do {
                if bodyDictionary != nil {
                    let jsonBody = try JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    request.httpBody = jsonBody
                }
            } catch let error as NSError {
                print("Error serializing JSON:", error)
                return
            }
        }
        if SMTokenManager().getToken() != nil {
            request.setValue(SMTokenManager().getToken(), forHTTPHeaderField: self.authorizationHeaderField)
        } else {
            print("Error, no token for current user, must authenticate first.")
            return
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                print("Error in request: ", error)
                returnedJSON(nil)
            } else if data != nil {
                let jsonData = self.handleJSONData(dataToSerialize: data! as NSData)
                returnedJSON(jsonData)
            }
        })
        task.resume()
    }
    
    func handleJSONData(dataToSerialize: NSData) -> NSArray? {
        do {
            let json = try JSONSerialization.jsonObject(with: dataToSerialize as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let jsonArray = json as? NSArray {
                return jsonArray
            } else if let jsonDictionary = json as? NSDictionary {
                let arrayedDictionary: [NSDictionary] = [jsonDictionary]
                return arrayedDictionary as NSArray?
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
