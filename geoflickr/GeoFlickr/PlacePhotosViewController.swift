//
//  PlacePhotosViewController.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/3/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class PlacePhotosViewController: FlickrPhotosViewController {
    var place_id: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.url            = FlickrFetcher.URLforPhotoInPlace(self.place_id, maxResults: 25)
        self.dataFetched    = FlickrPhotoData()
        self.fetchData()
    }
    
    func prepareImageViewController(ivc: ImageViewController, toDisplayPhoto photo: NSDictionary) {
        ivc.photoData   = photo
        ivc.imageURL    = FlickrFetcher.URLforPhoto(photo, format: .FlickrPhotoFormatLarge)
        ivc.title       = photo.valueForKeyPath(FLICKR_PHOTO_TITLE) as String
    }
        
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier: String  = "Photo Cell"
        var cell: UITableViewCell   = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        var photoData: NSDictionary = self.dataFetched.getDataAtIndex!(indexPath.row)
        cell.textLabel.text         = photoData.valueForKeyPath(FLICKR_PHOTO_TITLE) as String
        cell.detailTextLabel.text   = photoData.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (sender.isKindOfClass(UITableViewCell)) {
            var indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
            if (indexPath != nil) {
                if (segue.identifier == "Display Photo") {
                    if (segue.destinationViewController.isKindOfClass(ImageViewController)) {
                        self.prepareImageViewController(segue.destinationViewController as ImageViewController, toDisplayPhoto: self.dataFetched.getDataAtIndex!(indexPath.row) as NSDictionary)
                    }
                }
            }
        }
    }
    
}