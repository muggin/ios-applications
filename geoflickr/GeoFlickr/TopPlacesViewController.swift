//
//  TopPlacesViewController.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/1/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class TopPlacesViewController: FlickrPhotosViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.url            = FlickrFetcher.URLforTopPlaces()
        self.dataFetched    = FlickrPlaceData()
        self.fetchData()
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return self.dataFetched.sectionNameAtIndex!(section)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> FlickrPlaceTableViewCell! {
        var cellIdentifier: String          = "Photo Country Cell"
        var cell: FlickrPlaceTableViewCell  = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as FlickrPlaceTableViewCell
        var placeData: NSDictionary         = self.dataFetched.getDataAtIndex!(indexPath.row, inSection: indexPath.section) as NSDictionary
        var content: [String]               = (placeData.valueForKeyPath(FLICKR_PLACE_NAME) as String).componentsSeparatedByString(", ")
        cell.textLabel.text                 = content[0]
        cell.detailTextLabel.text           = (content.count == 3) ? content[1] : ""
        cell.place_id                       = placeData.valueForKey(FLICKR_PLACE_ID) as String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.destinationViewController.isKindOfClass(PlacePhotosViewController)) {
            var destinationVC       = segue.destinationViewController as PlacePhotosViewController
            var senderCell          = sender as FlickrPlaceTableViewCell
            destinationVC.title     = senderCell.textLabel.text
            destinationVC.place_id  = senderCell.place_id
        }
    }
    
}