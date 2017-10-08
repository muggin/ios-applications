//
//  Message.swift
//  Angelhack
//
//  Created by Wojciech Kryscinski on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class Message: Dictionarializable {
    var header: Header
    var body: Body
    var meta: Meta
    
    var hashString: String {
        let digestInput = "\(meta.timestamp)\(body.category.rawValue)\(body.message)"
        return digestInput.md5
    }
    
    typealias MessageDictionary = [String: [String: String]]
    typealias HeaderDictionary = [String: String]
    typealias BodyDictionary = [String: String]
    typealias MetaDictionary = [String: String]
    typealias Category = Message.Body.Category
    
    init() {
        self.header = Header()
        self.body = Body()
        self.meta = Meta()
    }
    
    init(header: Header, body: Body, meta: Meta) {
        self.header = header
        self.body = body
        self.meta = meta
    }
    
    func dictionarialize() -> MessageDictionary {
        var messageDictionary: MessageDictionary = ["body": body.dictionarialize(),
                                                    "header": header.dictionarialize(),
                                                    "meta": meta.dictionarialize()]
        
        return messageDictionary
    }
    
    func undictionarialize(messageDictionary: MessageDictionary) {
        if let body = messageDictionary["body"],
            let header = messageDictionary["header"],
                let meta = messageDictionary["meta"] {
                
                self.body.undictionarialize(body)
                self.header.undictionarialize(header)
                self.meta.undictionarialize(meta)
        } else {
            println("Error undictionarializing Message")
        }
    }
    
    class Header: Dictionarializable {
        var publicKey: String = ""
        var name: String = ""
        var id: String = ""
        var signature: String = ""
        
        init() {
        }
        
        init(publicKey: String, name: String, id: String, signature: String) {
            self.publicKey = publicKey
            self.name = name
            self.id = id
            self.signature = signature
        }
        
        func dictionarialize() -> HeaderDictionary {
            var headerDictionary: BodyDictionary = ["public_key": publicKey,
                                                    "name": name,
                                                    "id": id,
                                                    "signature": signature]
            
            return headerDictionary
        }
        
        func undictionarialize(headerDictionary: HeaderDictionary) {
            if let publicKey = headerDictionary["public_key"],
                let name = headerDictionary["name"],
                let id = headerDictionary["id"],
                let signature = headerDictionary["signature"]{
                    self.publicKey = publicKey
                    self.name = name
                    self.id = id
                    self.signature = signature
            } else {
                
                println("Error undictionarializing Header")
            }
        }
    }
    
    class Body: Dictionarializable {
        
        enum Category: String {
            case Standard = "S", Important = "I"
        }
        
        var message: String = ""
        var category: Category = Category.Standard
        var signature: String = ""
        
        init() {
        }
        
        init(message: String, category: Category, signature: String) {
            self.message = message
            self.category = category
            self.signature = signature
        }
        
        func dictionarialize() -> BodyDictionary {
            var bodyDictionary: BodyDictionary = ["message": message,
                                                    "category": category.rawValue,
                                                    "signature": signature]
            
            return bodyDictionary
        }
        
        func undictionarialize(bodyDictionary: BodyDictionary) {
            if let message = bodyDictionary["message"],
                let categoryString = bodyDictionary["category"],
                let signature = bodyDictionary["signature"],
                let category = Category(rawValue: categoryString) {
                    self.message = message
                    self.category = category
                    self.signature = signature
            } else {
                println("Error undictionarializing Body")
            }
        }
    }
    
    class Meta: Dictionarializable {
        var ttl: Int = 0
        var timestamp: Int = 0
        
        init() {
        }
        
        init(ttl: Int, timestamp: Int) {
            self.ttl = ttl
            self.timestamp = timestamp
        }
        
        func dictionarialize() -> MetaDictionary {
            var metaDictionary: MetaDictionary = ["ttl": String(ttl),
                                                  "timestamp": String(timestamp)]
            return metaDictionary
        }
        
        func undictionarialize(metaDictionary: MetaDictionary) {
            if let ttlString = metaDictionary["ttl"],
                let ttl = ttlString.toInt(),
                let timestampString = metaDictionary["timestamp"],
                let timestamp = timestampString.toInt() {
                    self.ttl = ttl
                    self.timestamp = timestamp
            } else {
                println("Error undictionarializing Meta")
            }
        }
    }
}