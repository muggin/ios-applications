//
//  MessageManager.swift
//  Angelhack
//
//  Created by Alexander Juda on 24/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MessageManager: NSObject, PLPartyTimeDelegate {
    let partyTime = PLPartyTime(serviceType: "whisper")
    
    var seenMessages = Set<String>()
    
    override init() {
        super.init()
        partyTime.delegate = self
    }
    
    func start() {
        partyTime.joinParty()
    }
    
    func stop() {
        partyTime.leaveParty()
    }
    
    func sendMessage(message: Message) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(message.dictionarialize())
        var error: NSError?
        
        self.partyTime.sendData(data, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if error != nil {
            println(error)
        }
        
        
    }
    
    // MARK: - Party Time data source
    
    func partyTime(partyTime: PLPartyTime!, failedToJoinParty error: NSError!) {
        println(error)
    }
    
    func partyTime(partyTime: PLPartyTime!, peer: MCPeerID!, changedState state: MCSessionState, currentPeers: [AnyObject]!) {
        println("\(peer.displayName) changed state to \(state.rawValue)")
    }
    
    func partyTime(partyTime: PLPartyTime!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        println("received data from \(peerID.displayName)")
        if let messageDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Message.MessageDictionary {
            let message = Message()
            message.undictionarialize(messageDictionary)
            
            let messageHash = message.hashString
            if !seenMessages.contains(messageHash) {
                // message not seen yet
                seenMessages.insert(messageHash)
                
                if message.meta.ttl > 0 {
                    // still valid to send
                    message.meta.ttl -= 1
                    let data = NSKeyedArchiver.archivedDataWithRootObject(message.dictionarialize())
                    var error: NSError?
                    partyTime.sendData(data, withMode: MCSessionSendDataMode.Reliable, error: &error)
                    
                    let center = NSNotificationCenter.defaultCenter()
                    center.postNotificationName("didReceiveNewMessage", object: self, userInfo: ["message" : message])
                }
            }
            
        }
    }
}