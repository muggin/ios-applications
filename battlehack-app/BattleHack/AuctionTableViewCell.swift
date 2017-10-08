//
//  SellItemTableViewCell.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class AuctionTableViewCell : UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var filledHeartButton: UIButton!
    
    var auction: Auction!
    
    @IBAction func heartButtonTouched(sender: AnyObject) {
        self.heartButton.hidden = true
        self.filledHeartButton.hidden = false
    }
    
    @IBAction func filledHeartButtonTouched(sender: AnyObject) {
        self.heartButton.hidden = false
        self.filledHeartButton.hidden = true
    }
}