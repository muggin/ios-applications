//
//  LoginCredentials.swift
//  BattleHack
//
//  Created by Wojciech Kryscinski on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class LoginCredentials : JsonSerializable {
    var email: String!
    var password: String!
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func deserialize(jsonObject: [String : AnyObject]) {
        if let
            email: String       = jsonObject["email"] as? String,
            password: String    = jsonObject["password"] as? String {
                self.email = email
                self.password = password
        }
    }
    
    func serialize() -> [String : AnyObject] {
        var jsonObject: [String: AnyObject] = [
            "email"     : email,
            "password"  : password
        ]
        return jsonObject
    }
}