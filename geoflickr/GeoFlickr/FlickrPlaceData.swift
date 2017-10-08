//
//  FlickrCountryData.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/2/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation

class FlickrPlaceData: FlickrDataProtocol {
    
    var data: NSMutableDictionary = NSMutableDictionary()
    var countryNames: NSMutableArray = NSMutableArray()
    
    func addData(place: NSDictionary) {
        var contentArray: String = place.valueForKey(FLICKR_PLACE_NAME) as String
        var content = contentArray.componentsSeparatedByString(",")
        var sectionKey = content.count == 3 ? content[2] : content[1]
        if let placeArray: NSMutableArray = data.valueForKey(sectionKey) as? NSMutableArray {
            placeArray.addObject(place)
            placeArray.sortUsingComparator() {(a: AnyObject!, b: AnyObject!) in
                var aDic = a as NSDictionary
                var bDic = b as NSDictionary
                var aStr = a.valueForKey(FLICKR_PLACE_NAME) as String
                var bStr = b.valueForKey(FLICKR_PLACE_NAME) as String
                return aStr.compare(bStr)}
        } else {
            data.setValue(NSMutableArray(object: place), forKey: sectionKey)
            self.countryNames.addObject(sectionKey)
            self.countryNames.sortUsingSelector(Selector("compare:"))
        }
    }
    
    func parseDictionaryResults(results: NSDictionary) {
        self.data.removeAllObjects()
        self.countryNames.removeAllObjects()
        var placeDataList: [NSDictionary] = results.valueForKeyPath(FLICKR_RESULTS_PLACES) as [NSDictionary]
        for place in placeDataList {
            self.addData(place)
        }
    }
    
    func getDataAtIndex(index: Int, inSection section: Int) -> NSDictionary {
        var sectionKey      = self.countryNames[section] as NSString
        var sectionArray    = self.data.valueForKey(sectionKey) as NSArray
        
        return sectionArray[index] as NSDictionary
    }
    
    func dataCount() -> Int {
        var dataCount: Int = 0
        for sectionKey: String in data.allKeys as [String] {
            dataCount += (data.valueForKey(sectionKey) as NSArray).count
        }
        return dataCount
    }
    
    func sectionCount() -> Int {
        return self.countryNames.count
    }
    
    func dataCountInSection(index: Int) -> Int {
        var sectionKey = self.countryNames[index] as String
        var sectionArray = self.data.valueForKey(sectionKey) as NSArray
        return sectionArray.count
    }
    
    func sectionNameAtIndex(index: Int) -> String {
        var sectionKey = self.countryNames[index] as String
        return sectionKey
    }
}