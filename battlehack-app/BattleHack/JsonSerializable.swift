//
//  JsonSerializable.swift
//  BattleHack
//
//  Created by Wojciech Kryscinski on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol JsonSerializable {
    func deserialize(jsonObject: [String: AnyObject])
    func serialize() -> [String: AnyObject]
}