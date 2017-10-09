//
//  PlayingCardGameViewController.swift
//  CardGame
//
//  Created by Wojtek on 7/17/14.
//
//

import Foundation
import UIKit

class PlayingCardGameViewController: CardGameViewController {
    //MARK: Properties
    override var gameName: String {
    get {
        return "Matchismo"
    }
    }
    
    override var gameMode: CardMatchingGame.GameMode {
    get {
        return .Double
    }
    }
    
    
    //MARK: UI functions
    override func updateUI() {
        for (i,cardButton) in enumerate(cardButtons!) {
            var card = game.cards[i]
            cardButton.setTitle(self.titleForCard(card), forState: UIControlState.Normal)
            cardButton.setBackgroundImage(self.backgroundImageForCard(card), forState: UIControlState.Normal)
            cardButton.enabled = !card.matched
        }
        self.updateScoreLabel()
    }
    
    
    //MARK: Other functions
    override func createDeck() -> Deck? {
        return PlayingCardDeck()
    }
    
    func backgroundImageForCard(card: Card) -> UIImage {
        return UIImage(named: card.chosen ? "cardfront" : "cardback")
    }
    
    func titleForCard(card:Card) -> String? {
        return card.chosen ? card.contents : ""
    }
    
}