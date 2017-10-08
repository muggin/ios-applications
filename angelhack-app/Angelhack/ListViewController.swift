//
//  ListViewController.swift
//  Angelhack
//
//  Created by Alexander Juda on 24/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        let center = NSNotificationCenter.defaultCenter()
        self.tableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.05)
        self.tableView.opaque = false;
        self.tableView.backgroundView = nil;
        center.addObserver(self, selector: "didReceiveNewMessage:", name: "didReceiveNewMessage", object: nil)
    }
    
    func didReceiveNewMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: Message]
        if let message = userInfo["message"] {
            messages.insert(message, atIndex: 0)
            tableView.reloadData()
        }
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.tableView.separatorInset = UIEdgeInsetsZero
//        self.tableView.layoutMargins = UIEdgeInsetsZero
//    }
    
    // MARK: table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: WhisperCell
        let message = messages[indexPath.row]
        
        switch message.body.category {
        case Message.Category.Important:
            cell = tableView.dequeueReusableCellWithIdentifier("importantWhisperCell", forIndexPath: indexPath) as! WhisperCell
        case Message.Category.Standard:
            cell = tableView.dequeueReusableCellWithIdentifier("regularWhisperCell", forIndexPath: indexPath) as! WhisperCell
        }
        
        cell.messageLabel.text = message.body.message
        cell.authorLabel.text = "\(message.header.name) says:"
        cell.separatorInset = UIEdgeInsetsZero
        
        return cell
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsetsZero
//        cell.preservesSuperviewLayoutMargins = false
//        cell.layoutMargins = UIEdgeInsetsZero
//    }
}