//
//  TokenManager.swift
//  fillr
//
//  Created by Steven McMurray on 5/8/16.
//  Copyright © 2016 Steven McMurray. All rights reserved.
//

import Foundation
import FXKeychain

struct SMTokenManager {
    
    let tokenKey = "token"
    
    func saveToken(tokenToSave: String) {
        FXKeychain.default().setObject(tokenToSave, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return FXKeychain.default().object(forKey: tokenKey) as? String
    }
}
