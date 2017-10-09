//
//  GameHistoryViewController.swift
//  CardGame
//
//  Created by Wojtek on 7/19/14.
//
//

import Foundation
import UIKit

class GameHistoryViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var textWindow: UITextView!
    var colorTheme: UIColor = UIColor.whiteColor()
    var gameHistoryText: NSAttributedString = NSAttributedString() {
    didSet {
        if (self.view.window) {
            self.updateUI()
        }
    }
    }
    
    
    //MARK: UI functions
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = self.colorTheme
        self.navigationController.navigationBar.tintColor = self.colorTheme
        self.updateUI()
    }
    
    func updateUI() {
        textWindow.attributedText = self.gameHistoryText
    }
    
}