//
//  Deck.swift
//  CardGame
//
//  Created by Wojtek on 7/15/14.
//
//

import Foundation

class Deck {
    //MARK: Properties
    var cards:[Card] = []
    
    
    
    ///MARK: Initializers
    init () {
        
    }
    
    
    //MARK: Other functions
    func addCard(card: Card, atTop:Bool=false) {
        if atTop {
            self.cards.insert(card, atIndex: 0)
        } else {
            self.cards.append(card)
        }
    }
    
    func drawRandomCard()->Card? {
        var randomCard:Card?
        if (self.cards.count != 0) {
            var index = Int(arc4random()) % self.cards.count
            randomCard = self.cards[index]
            self.cards.removeAtIndex(index)
        }
        NSLog("\(self.cards.count) cards left.")
        return randomCard
    }
}
