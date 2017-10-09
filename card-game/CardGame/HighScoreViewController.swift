//
//  HighScoreViewController.swift
//  CardGame
//
//  Created by Wojtek on 7/20/14.
//
//

import Foundation
import UIKit

class HighScoreViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var textView: UITextView!
    @IBOutlet var scoreSortButton: UIButton!
    @IBOutlet var durationSortButton: UIButton!
    @IBOutlet var nameSortButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    var compareFunction: ((GameDetails, GameDetails) -> Bool)!
    var gameHistory: [GameDetails] = []
    
    
    //MARK: Initializers
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getScoreHistory()
        self.updateUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("recieveHighScoreNotification:"), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    
    //MARK: IBAction functions
    @IBAction func clearButtonTouched() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("scoreHistoryArray")
        userDefaults.synchronize()
    }
    
    @IBAction func sortButtonTouched(sender: UIButton) {
        if (sender === scoreSortButton) {
            self.compareFunction = { $0.gameScore > $1.gameScore }
        } else if (sender === durationSortButton) {
            self.compareFunction = { $0.gameDuration < $1.gameDuration }
        } else if (sender === nameSortButton) {
            self.compareFunction = { $0.gameName < $1.gameName }
        }
        self.sortHistoryWithCompareFunction()
        self.updateUI()
    }

    
    //MARK: Other functions
    func recieveHighScoreNotification(notification: NSNotification) {
        if (notification.name == NSUserDefaultsDidChangeNotification) {
            self.getScoreHistory()
            self.updateUI()
        }
    }
    
    func getScoreHistory() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData = userDefaults.objectForKey("scoreHistoryArray") as? NSData
        if encodedData {
            self.gameHistory = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as [GameDetails]
            self.sortHistoryWithCompareFunction()
        } else {
            self.gameHistory = []
        }
    }
    
    func sortHistoryWithCompareFunction() {
        if !self.compareFunction {
            self.compareFunction = { $0.gameScore > $1.gameScore }
        }
        self.gameHistory.sort(self.compareFunction)
    }
        func updateUI() {
        var string = ""
        for (i, game) in enumerate(self.gameHistory) {
            string += "#\(i + 1) | Game: \(game.gameName) Score: \(game.gameScore) Duration: \(Int(game.gameDuration))\n"
        }
        self.textView.attributedText = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

}
