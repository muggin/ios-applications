//
//  BuyListViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class BuyListViewController : UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Auction.localAuctions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AuctionTableViewCell") as! AuctionTableViewCell
        
        let auction = Auction.localAuctions[indexPath.row] as Auction
        
        cell.photoImageView.image = auction.photo
        cell.descriptionLabel.text = auction.text
        cell.priceLabel.text = "\(auction.price)"
        cell.auction = auction
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "auctionDetailsSegue" {
            let detailsVC = segue.destinationViewController as! AuctionDetailsViewController
            let cell = sender as! AuctionTableViewCell
            detailsVC.auction = cell.auction
        }
    }
}