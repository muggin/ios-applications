//
//  Dictionarializable.swift
//  Angelhack
//
//  Created by Wojciech Kryscinski on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol Dictionarializable {
    typealias ValueType
    func dictionarialize() -> [String: ValueType]
    func undictionarialize(dictionary: [String: ValueType])
}