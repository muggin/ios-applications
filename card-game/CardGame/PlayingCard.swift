//
//  PlayingCard.swift
//  CardGame
//
//  Created by Wojtek on 7/15/14.
//
//

import Foundation



class PlayingCard: Card {
    //MARK: Properties
    let NUMBER_OF_MATCHING_CARDS = 1
    var suit:CardSuits
    var rank:CardRanks
    
    
    //MARK: Initializers
    init(suit:CardSuits, rank:CardRanks) {
        self.suit = suit
        self.rank = rank
    }
    
    
    //MARK: Other functions
    override var contents: String {
        get {
            return "\(rank.toRaw())\(suit.toRaw())"
        }
    
        set {
            self.contents = newValue
        }
    }
    
    override func match(cards: [Card]) -> Int {
        var score = 0
        for otherCard in cards as [PlayingCard] {
            if (self.rank == otherCard.rank) {
                score += 4
            } else if (self.suit == otherCard.suit) {
                score += 2
                
            }
        }
        return score
    }
    
    
    //MARK: Enumerators
    enum CardRanks:String {
        case Ace="A", Two="2", Three="3", Four="4", Five="5", Six="6", Seven="7", Eight="8", Nine="9", Ten="10", Jack="J", Queen="Q", King="K"
        static let allValues = [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]
    }
    
    enum CardSuits:String {
        case Spades="♠", Hearts="♥", Diamonds="♦", Clubs="♣"
        static let allValues = [Spades, Hearts, Diamonds, Clubs]
    }

}

