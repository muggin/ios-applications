//
//  SetDeck.swift
//  CardGame
//
//  Created by Wojtek on 7/18/14.
//
//

import Foundation

class SetDeck: Deck {
    //MARK: Initializers
    init() {
        super.init()
        for color in SetCard.Color.allValues {
            for shape in SetCard.Shape.allValues {
                for count in SetCard.Count.allValues {
                    for shade in SetCard.Shade.allValues {
                        self.cards.append(SetCard(color: color, shape: shape, count: count, shade: shade))
                    }
                }
            }
        }
        NSLog("Created SetDeck (\(self.cards.count) cards)")
    }
    
}