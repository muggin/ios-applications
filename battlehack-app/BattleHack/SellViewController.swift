//
//  SellViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class SellViewController : UIViewController, UITableViewDataSource, BackendConnectorDelegate {
    var backendConnector: BackendConnector!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendConnector = BackendConnector(serverAddress: "http://10.205.251.112:9000")
        backendConnector.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendConnector.getUserAuctions()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Auction.userAuctions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AuctionTableViewCell") as! AuctionTableViewCell
        
        let auction = Auction.userAuctions[indexPath.row] as Auction
        
        cell.photoImageView.image = auction.photo
        cell.descriptionLabel.text = auction.text
        cell.priceLabel.text = "£\(auction.price)"
        
        return cell
    }
    
    func didFetchUserAuctions(auctions: [Auction]?) {
        Auction.userAuctions.removeAll(keepCapacity: true)
        
        if let auctionList = auctions {
            for auction in auctionList {
                Auction.userAuctions.append(auction)
            }
        }
        tableView.reloadData()
    }
    
    func didPostUser() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newAuctionSegue" {
            let newVC = segue.destinationViewController as! NewAuctionViewController
            newVC.sellVC = self
        }
    }
}
