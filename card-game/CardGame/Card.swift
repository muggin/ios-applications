//
//  Card.swift
//  CardGame
//
//  Created by Wojtek on 7/15/14.
//
//

import Foundation

class Card {
    //MARK: Properties
    var contents:String { return "" }
    var chosen:Bool = false
    var matched:Bool = false
    
    
    //MARK: Other functions
    func match(cards: [Card])->Int {
        var score:Int = 0
        
        for card in cards {
            if (self.contents == card.contents) {
                score += 1
            }
        }
        return score
    }
    
}