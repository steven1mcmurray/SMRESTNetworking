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
        case .APIBase:
            return "https://..."
        case .AuthBase:
            return "https://..."
        }
    }
}