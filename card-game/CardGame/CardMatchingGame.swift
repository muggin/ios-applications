//
//  CardMatchingGame.swift
//  CardGame
//
//  Created by Wojtek on 7/15/14.
//
//

import Foundation


class CardMatchingGame {
    //MARK: Properties
    var clicks = 6
    var cards: [Card] = []xq
    var gameFinished: Bool = false
    private var MATCH_BONUS: Int = 4
    private var MISMATCH_PENALTY: Int = 2
    private var CHOICE_COST: Int = 1
    let gameHistory: GameHistory!
    private let gameMode: GameMode!
    private let gameDetails: GameDetails!
    
    
    //MARK: Initializers
    init(cardCount:Int, usingDeck deck: Deck?,  gameName:String, gameMode: GameMode) {
        self.gameMode = gameMode
        self.gameDetails = GameDetails(gameName: gameName)
        self.gameHistory = GameHistory()
        
        NSLog("New Game with gameMode: \(self.gameMode.toRaw())")
        
        for _ in 0..<cardCount {
            if var drawnCard = deck?.drawRandomCard() {
                self.cards.append(drawnCard)
            }
        }
    }
    
    //MARK: Other functions
    func cardAtIndex(index:Int) -> Card? {
        return (index < self.cards.count) ? self.cards[index] : nil
    }
    
    func checkGameState() {
        //TODO: Game finished algorithms
        self.clicks--
        if (self.clicks < 0) {
            self.gameFinished = true
            self.gameDetails.gameFinished()
            self.gameDetails.saveGameScore()
        }
    }
    
    func chooseCardAtIndex(index:Int) {
        if (!self.gameFinished) {
            if let card = cardAtIndex(index) {
                if (!card.matched) {
                    if (card.chosen) {
                        card.chosen = false
                    } else {
                        self.gameDetails.gameScore -= CHOICE_COST
                        self.gameHistory.addGameEvent(GameHistory.GameEvent.Choice, newCards: [card])
                        var otherCards = self.findChosenCards(card)
                        if otherCards.count == gameMode.toRaw() {
                            self.matchChosenCards(card, otherCards: otherCards)
                        }
                        card.chosen = true
                    }
                }
            }
        }
    }
    
    func findChosenCards(currentCard: Card) -> [Card] {
        var otherCards: [Card] = []
        for otherCard in self.cards {
            if (otherCard.chosen && !otherCard.matched) {
                otherCards.append(otherCard)
                if otherCards.count == gameMode.toRaw() {
                    break
                }
            }
        }
        return otherCards
    }
    
    func getGameScore() -> Int {
        return self.gameDetails.gameScore
    }
    
    func matchChosenCards(currentCard: Card, otherCards: [Card]) {
        var matchScore: Int = currentCard.match(otherCards)
        var matchedCards = [currentCard] + otherCards
        if (matchScore > 0) {
            let totalScore = matchScore * MATCH_BONUS
            self.gameDetails.gameScore += totalScore
            self.gameHistory.addGameEvent(GameHistory.GameEvent.Match, newCards: matchedCards, newPoints: totalScore)
            for card in matchedCards {
                card.matched = true
            }
            self.checkGameState()
        } else {
            self.gameDetails.gameScore -= MISMATCH_PENALTY
            self.gameHistory.addGameEvent(GameHistory.GameEvent.Mismatch, newCards: matchedCards, newPoints: -MISMATCH_PENALTY)
            for card in matchedCards {
                card.chosen = false
            }
        }
    }
    
    func setGameSettings(choiceCost: Int, matchBonus: Int, mismatchPenalty: Int) {
        self.CHOICE_COST = choiceCost
        self.MATCH_BONUS = matchBonus
        self.MISMATCH_PENALTY = mismatchPenalty
    }
    
    
    //MARK: Enumerators
    enum GameMode:Int {
        case Double=1, Triple=2, Quadruple=3, Quintuple=4
    }
    
}