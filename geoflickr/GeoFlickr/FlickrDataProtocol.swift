
//
//  FlickrDataProtocol.swift
//  GeoFlickr
//
//  Created by Wojtek on 8/3/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation

@objc protocol FlickrDataProtocol {
    //MARK: Properties
    //var data: NSMutableArray { get set }
    
    //MARK: Adding data
    func addData(NSDictionary)
    func parseDictionaryResults(NSDictionary)
    optional func parseArrayResults(results: NSArray)
    
    //MARK: Retrieving data
    optional func getDataAtIndex(Int) -> NSDictionary
    optional func getDataAtIndex(Int, inSection: Int) -> NSDictionary
    
    //MARK: Helper functions
    func dataCount() -> Int
    func sectionCount() -> Int
    func dataCountInSection(Int) -> Int
    optional func sectionNameAtIndex(Int) -> String
    
}
