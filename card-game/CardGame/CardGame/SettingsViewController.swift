//
//  SettingsViewController.swift
//  CardGame
//
//  Created by Wojtek on 7/20/14.
//
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    //MARK: Properties
    let userDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet var flipValueLabel: UILabel!
    @IBOutlet var matchValueLabel: UILabel!
    @IBOutlet var mismatchValueLabel: UILabel!
    @IBOutlet var flipValueSwitch: UIStepper!
    @IBOutlet var matchValueSwitch: UIStepper!
    @IBOutlet var mismatchValueSwitch: UIStepper!
    
    
    //MARK: UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let newValue = defaults.objectForKey("choiceCost") as? Int {
            self.flipValueSwitch.value = Double(newValue)
        }
        
        if let newValue = defaults.objectForKey("matchBonus") as? Int {
            self.matchValueSwitch.value = Double(newValue)
        }
        if let newValue = defaults.objectForKey("mismatchPenalty") as? Int {
            self.mismatchValueSwitch.value = Double(newValue)
        }
        updateLabels()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveGameSettings()
    }
    
    func updateLabels() {
        self.flipValueLabel.text = "\(Int(flipValueSwitch.value))"
        self.matchValueLabel.text = "\(Int(matchValueSwitch.value))"
        self.mismatchValueLabel.text = "\(Int(mismatchValueSwitch.value))"
    }
    
    
    //MARK: IBAction functions
    @IBAction func switchValueChanged() {
        updateLabels()
    }
    
    
    //MARK: Other functions
    func saveGameSettings() {
        userDefaults.setObject(Int(self.flipValueSwitch.value), forKey: "choiceCost")
        userDefaults.setObject(Int(self.matchValueSwitch.value), forKey: "matchBonus")
        userDefaults.setObject(Int(self.mismatchValueSwitch.value), forKey: "mismatchPenalty")
        userDefaults.synchronize()
    }
    
}