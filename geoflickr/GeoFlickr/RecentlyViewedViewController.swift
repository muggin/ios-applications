//
//  RecentlyViewedViewController.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/1/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class RecentlyViewedViewController: PlacePhotosViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("respondToNewData:"), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func fetchData() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var aQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(aQueue, {
            var encodedData = userDefaults.objectForKey("recentlyViewedPhotos") as? NSData
            var recentPhotosArray: NSMutableArray = NSMutableArray()
            if (encodedData != nil) {
                recentPhotosArray = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as NSMutableArray
            }
            self.dataFetched.parseArrayResults!(recentPhotosArray as NSArray)
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
            self.refreshControl.endRefreshing()
        })
    }
    
    func respondToNewData(notification: NSNotification) {
        self.fetchData()
    }
}
