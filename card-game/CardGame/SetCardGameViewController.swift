//
//  SetCardGameViewController.swift
//  CardGame
//
//  Created by Wojtek on 7/18/14.
//
//

import Foundation
import UIKit

class SetCardGameViewController: CardGameViewController {
    //MARK: Properties
    override var gameName: String {
    get {
        return "Set"
    }
    }
    
    override var gameMode: CardMatchingGame.GameMode {
    get {
        return .Triple
    }
    }
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("\(self.gameMode.toRaw())")
        self.updateUI()
    }

    override func updateUI() {
        for (i,cardButton) in enumerate(cardButtons!) {
            var card = game.cards[i]
            if card.chosen {
                cardButton.alpha = 0.3
            } else {
                cardButton.alpha = 1.0
            }
            cardButton.setAttributedTitle(self.titleForCard(card), forState: UIControlState.Normal)
            cardButton.enabled = !card.matched
        }
        self.updateScoreLabel()
    }
    
    //MARK: Other functions
    override func createDeck() -> Deck? {
        return SetDeck()
    }
    override func parseCards(cards: [Card]) -> NSAttributedString {
        var outputString: NSMutableAttributedString = NSMutableAttributedString()
        for card in cards {
            outputString.appendAttributedString(self.titleForCard(card))
        }
        outputString.appendAttributedString(NSAttributedString(string: " "))
        return outputString
    }
    
    func titleForCard(card:Card) ->  NSAttributedString {
        if (!card.matched) {
            let setCard = card as SetCard
            var text: String = ""
            var strokeWidth: String!
            var textColor: UIColor!
            var strokeColor: UIColor!
            
            for _ in 0..<setCard.count.toRaw() {
                text += setCard.shape.toRaw()
            }
            
            switch setCard.color {
            case .Green:
                textColor = UIColor.greenColor()
                strokeColor = UIColor.greenColor()
            case .Purple:
                textColor = UIColor.purpleColor()
                strokeColor = UIColor.purpleColor()
            case .Red:
                textColor = UIColor.redColor()
                strokeColor = UIColor.redColor()
            }
            
            switch setCard.shade {
            case .Solid:
                strokeWidth = "0"
            case .Striped:
                textColor = textColor.colorWithAlphaComponent(0.2)
                strokeWidth = "-8"
            case .Open:
                textColor = textColor.colorWithAlphaComponent(0)
                strokeWidth = "8"
            }
            
            return NSAttributedString(string: text, attributes: [
                NSForegroundColorAttributeName:textColor,
                NSStrokeColorAttributeName:strokeColor,
                NSStrokeWidthAttributeName:strokeWidth])
        } else {
            return NSAttributedString(string: "")
        }
    }
    
}