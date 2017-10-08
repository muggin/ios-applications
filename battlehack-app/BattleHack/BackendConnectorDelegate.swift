//
//  BackendConnectorDelegate.swift
//  BattleHack
//
//  Created by Wojciech Kryscinski on 26/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

@objc protocol BackendConnectorDelegate {
    
    optional func didFetchLocalAuctions(auctions: [Auction]?)
    optional func didFetchUserAuctions(auctions: [Auction]?)
    optional func didPostAuction()
    optional func didPostUser()
}