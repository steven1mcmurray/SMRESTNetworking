//
//  RESTTypes.swift
//  ChaFuelDriver
//
//  Created by Steven McMurray on 6/27/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//

import Foundation

enum RequestMethod {
    
    case GET
    case POST
    case PUT
    case DELETE
    
    var methodType: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }
}