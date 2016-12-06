//
//  BoolParser.swift
//  fillr
//
//  Created by Steven McMurray on 5/9/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//

import Foundation

struct SMBoolParser {
    
    func parseServerBool(numberToParse: Int) -> Bool {
        var boolToReturn = false
        if numberToParse == 1 {
            boolToReturn = true
        }
        return boolToReturn
    }
}