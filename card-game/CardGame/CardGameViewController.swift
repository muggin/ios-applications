import Foundation
import UIKit


class CardGameViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var redealButton: UIButton!
    @IBOutlet var cardButtons : [UIButton]!
    let gameName: String = "Card Game"
    var gameMode: CardMatchingGame.GameMode {
    get{
        return .Double
    }
    }
    lazy var game: CardMatchingGame = CardMatchingGame(cardCount: self.cardButtons.count, usingDeck: self.createDeck(), gameName: self.gameName, gameMode: self.gameMode)
    
    
    //MARK: Initializers
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateGameSettings()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("recieveGameSettingsNotification:"), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "showGameHistory") {
            if(segue.destinationViewController is GameHistoryViewController) {
                var segueViewController = segue.destinationViewController as GameHistoryViewController
                var currentViewBackgroundColor: UIColor = self.view.backgroundColor
                segueViewController.gameHistoryText = self.getGameHistory()
                segueViewController.colorTheme = currentViewBackgroundColor
            }
        }
    }
    
    func updateUI() {
        // abstract
    }
    
    func updateGameSettings() {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let choiceCost = defaults.objectForKey("choiceCost") as? Int
        let matchBonus = defaults.objectForKey("matchBonus") as? Int
        let mismatchPenalty = defaults.objectForKey("mismatchPenalty") as? Int
        
        if (choiceCost && matchBonus && mismatchPenalty) {
            game.setGameSettings(choiceCost!, matchBonus: matchBonus!, mismatchPenalty: mismatchPenalty!)
        }
    }
    
    func updateScoreLabel() {
        self.scoreLabel.text = "Score: \(self.game.getGameScore())"
    }
    
    
    //MARK: IBAction functions
    @IBAction func touchCardButton(sender:UIButton) {
        var chosenButtonIndex: Int = 0
        for (i, cardButton) in enumerate(cardButtons!) {
            if sender == cardButton {
                chosenButtonIndex = i
                break
            }
        }
        game.chooseCardAtIndex(chosenButtonIndex)
        self.updateUI()
        NSLog("\(self.gameName) move - \(self.gameMode.toRaw())")
    }
    
    @IBAction func touchRedealButton() {
        self.game = CardMatchingGame(cardCount: self.cardButtons.count, usingDeck: self.createDeck(), gameName: self.gameName, gameMode: self.gameMode)
        self.updateGameSettings()
        NSLog("\(self.gameName) move - \(self.gameMode.toRaw())")
        self.updateUI()
    }
    
    
    //MARK: Other functions
    func createDeck() -> Deck? {
        // abstract
        return nil
    }
    
    func getGameHistory() -> NSAttributedString {
        var outputString: NSMutableAttributedString = NSMutableAttributedString()
        
        for event in game.gameHistory.events {
            outputString.appendAttributedString(NSAttributedString(string: "\(event.event.toRaw()) "))
            outputString.appendAttributedString(self.parseCards(event.cards))
            outputString.appendAttributedString(NSAttributedString(string: "(\(event.points) points)\n"))
        }
        return outputString
    }
    
    func parseCards(cards: [Card]) -> NSAttributedString {
        var outputString: NSMutableAttributedString = NSMutableAttributedString()
        for card in cards {
            outputString.appendAttributedString(NSAttributedString(string: "\(card.contents)"))
        }
        outputString.appendAttributedString(NSAttributedString(string: ""))
        return outputString
    }
    
    func recieveGameSettingsNotification(notification: NSNotification) {
        if (notification.name == NSUserDefaultsDidChangeNotification) {
            self.updateGameSettings()
        }
    }
    
}