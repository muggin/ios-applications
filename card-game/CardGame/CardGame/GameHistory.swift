//
//  GameHistory.swift
//  CardGame
//
//  Created by Wojtek on 7/22/14.
//
//

import Foundation

class GameHistory {
    //MARK: Properties
    var events: [(event: GameEvent, cards: [Card], points: Int)] = []
    
    
    //MARK: Other functions
    func addGameEvent(newEvent: GameEvent, newCards: [Card] = [], newPoints: Int = 0) {
        self.events.append(event: newEvent, cards: newCards, points: newPoints)
    }
    
    
    //MARK: Enumerators
    enum GameEvent:String {
        case Choice = "Choice", Match = "Match", Mismatch = "Mismatch", Finished = "Finished"
    }
}