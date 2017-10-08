//
//  MessageProcessor.swift
//  Angelhack
//
//  Created by Wojciech Kryscinski on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class MessageProcessor {
    
    
}

class MessageBuilder {
    private static let TTL_STANDARD: Int = 3
    private static let TTL_IMPORTANT: Int = 5
    private static var messageHeader: Message.Header = {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var messageHeader = Message.Header()
        if let headerDictionary = userDefaults.objectForKey("message_header") as? [String: String] {
            messageHeader.undictionarialize(headerDictionary)
        }
        return messageHeader
    }()
    
    static func build(#text: String, andCategory category: Message.Category, sign: Bool) -> Message {
        let messageBody = Message.Body(message: text,  category: category, signature: "")
        
        if (sign) {
            // Sign messageBody
        }
        
        var ttlValue: Int = (category == Message.Category.Important) ? TTL_IMPORTANT : TTL_STANDARD
        let messageMeta = Message.Meta(ttl: ttlValue, timestamp: 0)
        
        return Message(header: self.messageHeader, body: messageBody, meta: messageMeta)
    }
}

class MessageVerifier {
    
    func verify(message: Message) -> Bool {
        return true
    }
}

class MessageSigner {
    private lazy var serverPublicKey: String = {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var serverPublicKey = ""
        if let savedPublicKey = userDefaults.objectForKey("public_key") as? String {
            serverPublicKey = savedPublicKey
        }
        
        return serverPublicKey
    }()
    private lazy var clientPrivateKey: String = {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var serverPrivateKey = ""
        if let savedPrivateKey = userDefaults.objectForKey("private_key") as? String {
            serverPrivateKey = savedPrivateKey
        }
        
        return serverPrivateKey
    }()
    
    func signMessage(messageBody: Message.Body) {
        messageBody.signature = "Signed by MessageSigner"
    }
}