//
//  FlickrPhotosTVC.swift
//  Shutterbug
//
//  Created by Wojtek on 7/30/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotosTVC: UITableViewController {
    var photos: NSArray = [] {
    didSet {
        self.tableView.reloadData()
    }
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func prepareImageViewController(ivc: ImageViewController, toDisplayPhoto photo: NSDictionary) {
        ivc.imageURL = FlickrFetcher.URLforPhoto(photo, format: .FlickrPhotoFormatLarge)
        ivc.title = photo.valueForKeyPath(FLICKR_PHOTO_TITLE) as String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (sender.isKindOfClass(UITableViewCell)) {
            var indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
            if (indexPath != nil) {
                if (segue.identifier == "Display Photo") {
                    if (segue.destinationViewController.isKindOfClass(ImageViewController)) {
                        self.prepareImageViewController(segue.destinationViewController as ImageViewController, toDisplayPhoto: self.photos[indexPath.row] as NSDictionary)
                    }
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier: String = "Flickr Photo Cell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        var photo: NSDictionary = self.photos[indexPath.row] as NSDictionary
        cell.textLabel.text = photo.valueForKeyPath(FLICKR_PHOTO_TITLE) as String
        cell.detailTextLabel.text = photo.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
        
        return cell
    }
}