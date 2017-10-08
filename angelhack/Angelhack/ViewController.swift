//
//  ViewController.swift
//  Angelhack
//
//  Created by Alexander Juda on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let SERVICE_NAME = "whisper"

class ViewController: UIViewController, PLPartyTimeDelegate {
    @IBOutlet weak var messageSenderLabel: UILabel!
    @IBOutlet weak var messageTimestampLabel: UILabel!
    
    var partyTime: PLPartyTime!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.partyTime = PLPartyTime(serviceType: SERVICE_NAME)
        self.partyTime.delegate = self
        self.partyTime.joinParty()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------------------------- IBActions

    @IBAction func hiButtonTouched(sender: AnyObject) {
//        var longString = ""
//        
//        for i in 0...1000 {
//            longString.append("o" as Character)
//        }
//        
//        let message:[String: String] = ["hello": longString]
//        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
//        var error: NSError?
//        
//        self.partyTime.sendData(data, withMode: MCSessionSendDataMode.Reliable, error: &error)
//        
//        if error != nil {
//            println("\(error)")
//        }
        let header = Message.Header()
//        header.name = UIDevice.currentDevice.name
        header.name = UIDevice.currentDevice().name
        
//        let body = Message.Body(message: "Hello, World", signature: "")
        let body = Message.Body(message: "Hello!", category: Message.Body.Category.Standard, signature: "")
        
        let message = Message()
        message.header = header
        message.body = body
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(message.dictionarialize())
        var error: NSError?

        self.partyTime.sendData(data, withMode: MCSessionSendDataMode.Reliable, error: &error)

        if error != nil {
            println("\(error)")
        }
    }
    
    
    // -------------------------------------- PLPartyTimeDelegate
    
    func partyTime(partyTime: PLPartyTime!, peer: MCPeerID!, changedState state: MCSessionState, currentPeers: [AnyObject]!) {
        println("\(peer.displayName) changed state to \(state.rawValue)")
    }
    
    func partyTime(partyTime: PLPartyTime!, failedToJoinParty error: NSError!) {
        println("partyTime failed to join party")
    }
    
    func partyTime(partyTime: PLPartyTime!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
//        println("partyTime didReceiveData")
//        if let message: [String: String] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: String] {
//            println("received message")
//            let text: String? = message["hello"]
//            println("\(peerID.displayName) sent \(count(text!))")
//            
//            self.messageSenderLabel.text = peerID.displayName
//            
//            let now = NSDate()
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "HH:mm:ss"
//            self.messageTimestampLabel.text = formatter.stringFromDate(now)
//        }
        if let messageDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Message.MessageDictionary {
            let message = Message()
            message.undictionarialize(messageDictionary)
            
            self.messageSenderLabel.text = message.header.name
            self.messageTimestampLabel.text = message.body.message
        }
    }
    
    func partyTime(partyTime: PLPartyTime!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("partyTime did start receiving resource \(resourceName)")
    }
}

