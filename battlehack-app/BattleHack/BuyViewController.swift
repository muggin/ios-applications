//
//  BuyViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class BuyViewController : UIViewController, BackendConnectorDelegate {
    var backendConnector: BackendConnector!
    
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendConnector = BackendConnector(serverAddress: "http://10.205.251.112:9000")
        backendConnector.delegate = self
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            listContainerView.hidden = false
            mapContainerView.hidden = true
            break
            
        case 1:
            listContainerView.hidden = true
            mapContainerView.hidden = false
            break
            
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "buyListSegue" || segue.identifier == "buyMapSegue" {
            backendConnector.getLocalAuctions()
        }
    }
    
    func didFetchLocalAuctions(auctions: [Auction]?) {
        Auction.localAuctions.removeAll(keepCapacity: true)
        
        if let auctionList = auctions {
            for auction in auctionList {
                Auction.localAuctions.append(auction)
            }
        }
    }
}
