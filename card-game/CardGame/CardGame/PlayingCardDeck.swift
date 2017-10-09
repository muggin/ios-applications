//
//  PlayingCardDeck.swift
//  CardGame
//
//  Created by Wojtek on 7/15/14.
//
//

import Foundation

class PlayingCardDeck: Deck {
    //MARK: Initializers
    init() {
        super.init()
        for suit in PlayingCard.CardSuits.allValues {
            for rank in PlayingCard.CardRanks.allValues {
                self.cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
        NSLog("Created PlayingCardDeck (\(self.cards.count) cards)")
    }
    
}