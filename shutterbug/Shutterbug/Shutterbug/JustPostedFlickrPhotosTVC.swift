//
//  JustPostedFlickrPhotosTVC.swift
//  Shutterbug
//
//  Created by Wojtek on 7/30/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class JustPostedFlickrPhotosTVC: FlickrPhotosTVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
        NSLog("Hello")
    }
    
    func fetchPhotos() {
        var url: NSURL = FlickrFetcher.URLforRecentGeoreferencedPhotos()
        //WARNING Blocks main thread
        var jsonResults: NSData = NSData(contentsOfURL: url)
        var propertyListResults: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonResults, options: nil, error: nil) as NSDictionary
        var photos: NSArray = propertyListResults.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSArray
        self.photos = photos
    }
}