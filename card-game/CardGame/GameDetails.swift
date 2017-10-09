//
//  GameScore.swift
//  CardGame
//
//  Created by Wojtek on 7/20/14.
//
//

import Foundation

class GameDetails: NSObject, NSCoding {
    //MARK: Properties
    var gameName: String!
    var gameScore: Int = 0
    var startTime: NSDate!
    var gameDuration: NSTimeInterval!
    
    
    //MARK: Initializers
    init(gameName: String) {
        super.init()
        self.gameName = gameName
        self.gameStarted()
    }
    
    init(coder decoder: NSCoder) {
        self.gameName = decoder.decodeObjectForKey("gameName") as String
        self.gameScore = decoder.decodeObjectForKey("gameScore") as Int
        self.startTime = decoder.decodeObjectForKey("startTime") as NSDate
        self.gameDuration = decoder.decodeObjectForKey("gameDuration") as NSTimeInterval
    }
    
    
    //MARK: Other functions
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.gameName, forKey:"gameName")
        encoder.encodeObject(self.gameScore, forKey:"gameScore")
        encoder.encodeObject(self.startTime, forKey: "startTime")
        encoder.encodeObject(self.gameDuration, forKey: "gameDuration")
    }
    
    func gameStarted() {
        self.startTime = NSDate.date()
    }
    
    func gameFinished() {
        self.gameDuration = NSDate.date().timeIntervalSinceDate(self.startTime)
    }
    
    func saveGameScore() {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData: NSData? = userDefaults.objectForKey("scoreHistoryArray") as? NSData
        var decodedScoreArray: [GameDetails]
        
        if encodedData {
            decodedScoreArray = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as [GameDetails]
            if (decodedScoreArray.count >= 5) {
                decodedScoreArray.removeLast()
            }
            decodedScoreArray.append(self)
        } else {
            decodedScoreArray = [self]
        }
        encodedData = NSKeyedArchiver.archivedDataWithRootObject(decodedScoreArray)
        userDefaults.setObject(encodedData, forKey: "scoreHistoryArray")
        userDefaults.synchronize()
    }

    
}