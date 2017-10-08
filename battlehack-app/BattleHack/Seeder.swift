//
//  Seeder.swift
//  BattleHack
//
//  Created by Alexander Juda on 26/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class Seeder {
    static func generateAuctions() -> [Auction] {
        var auctions: [Auction] = []
        
        for i in 0...10 {
            let auction = Auction()
            auction.photo = UIImage(named: "hacktory") as UIImage!
            auction.price = i*2
            auction.text = "This is an auction"
            
            let longitudeOffset = (Double(random()) % 100) / 100
            let latitudeOffset = (Double(random()) % 100) / 100
            
            auction.longitude = -0.059920 + longitudeOffset
            auction.latitude = 51.508805 + latitudeOffset
            
            auctions.append(auction)
        }
        
        return auctions
    }
}