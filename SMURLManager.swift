//
//  URLManager.swift
//  fillr
//
//  Created by Steven McMurray on 5/8/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//

/*
    To properly use SMRESTNetworking, set your URL bases in this enum. You can add/edit/delete cases as necessary. To add new bases, simply add the case for the base string and implement the string as the return value of the computed property - base
*/

import Foundation

enum SMURLManager {
    
    case APIBase
    case AuthBase

    var base: String {
        switch self {
            //Add and edit base cases here. Return the string values representing the base URL's. This example shows an APIBase and an AuthBase, where the AuthBase is used to authenticate a user and receive a token, and the APIBase is used to send authenticated requests.
        case .APIBase:
            return "https://..."
        case .AuthBase:
            return "https://..."
        }
    }
}