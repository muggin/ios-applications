//
//  FlickrPhotoData.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/3/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation

class FlickrPhotoData: FlickrDataProtocol {
    var data: NSMutableArray = NSMutableArray()
    
    func addData (photo: NSDictionary) {
        data.addObject(photo)
    }
    
    func parseDictionaryResults(results: NSDictionary) {
        self.data.removeAllObjects()
        var photoDataList: NSArray = results.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSArray
        for photoData: NSDictionary in photoDataList as [NSDictionary] {
            self.addData(photoData as NSDictionary)
        }
        
    }
    
    func parseArrayResults(results: NSArray) {
        self.data.removeAllObjects()
        for photoData: NSDictionary in results as [NSDictionary] {
            self.addData(photoData as NSDictionary)
        }
    }
    
    func getDataAtIndex(index: Int) -> NSDictionary {
        return data[index] as NSDictionary
    }
    
    func dataCount() -> Int {
        return data.count
    }
    
    func sectionCount() -> Int {
        return 1
    }
    
    func dataCountInSection(_: Int) -> Int {
        return self.dataCount()
    }
    

}