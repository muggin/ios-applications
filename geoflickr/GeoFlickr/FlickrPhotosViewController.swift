//
//  FlickrPhotosViewController.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/1/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotosViewController: UITableViewController {
    var dataFetched: FlickrDataProtocol!
    var url: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: Selector("fetchData"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func fetchData() {
        var jsonResults: NSData!
        var propertyListResults: NSDictionary!
        var aQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(aQueue, {
            jsonResults = NSData(contentsOfURL: self.url)
            propertyListResults = NSJSONSerialization.JSONObjectWithData(jsonResults, options: nil, error: nil) as NSDictionary
            self.dataFetched.parseDictionaryResults(propertyListResults)
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
            self.refreshControl.endRefreshing()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return self.dataFetched.sectionCount()
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.dataFetched.dataCountInSection(section)
    }
}