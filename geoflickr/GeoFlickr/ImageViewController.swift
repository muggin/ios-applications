//
//  ImageViewController.swift
//  iOS_Imaginarium
//
//  Created by Wojtek on 7/30/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    //MARK: Properties
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var scrollView: UIScrollView? {
    didSet {
        self.scrollView!.minimumZoomScale = 0.2
        self.scrollView!.maximumZoomScale = 2.0
        self.scrollView!.delegate = self
        self.scrollView!.contentSize = (self.image != nil) ? self.image!.size : CGSizeZero
    }
    }
    
    var imageURL: NSURL? {
    didSet {
        self.startDownloadingImage()
    }
    }
    
    var image: UIImage? {
    get {
        return self.imageView.image
    }
    set {
        self.imageView.image = newValue
        self.imageView.sizeToFit()
        if (self.scrollView != nil) {
            self.scrollView!.contentSize = (self.image != nil) ? self.image!.size : CGSizeZero
        }
        self.activityIndicator?.stopAnimating()
    }
    }
    
    lazy var imageView: UIImageView! = UIImageView()
    var photoData: NSDictionary!
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView?.addSubview(self.imageView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.imageView
    }
    
    func startDownloadingImage() {
        self.image = nil
        self.activityIndicator?.startAnimating()
        if (self.imageURL != nil) {
            var request = NSURLRequest(URL: self.imageURL)
            var configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            var session = NSURLSession(configuration: configuration)
            var task = session.downloadTaskWithRequest(request, completionHandler: {
                (localfile, response, error) in
                if (!error) {
                    if (request.URL.isEqual(self.imageURL)) {
                        var image = UIImage(data: NSData(contentsOfURL: localfile))
                        self.updateRecentlyViewedList()
                        dispatch_async(dispatch_get_main_queue(), {self.image = image})
                    }
                }
            })
            task.resume()
        }
    }
    
    func updateRecentlyViewedList() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData = userDefaults.objectForKey("recentlyViewedPhotos") as? NSData
        var recentPhotosArray:  NSMutableArray =  NSMutableArray()
        if (encodedData != nil) {
            recentPhotosArray = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as NSMutableArray
            if recentPhotosArray.containsObject(self.photoData) {
                recentPhotosArray.removeObject(self.photoData)
            } else if recentPhotosArray.count >= 20 {
                recentPhotosArray.removeLastObject()
            }
            recentPhotosArray.insertObject(self.photoData, atIndex: 0)
        } else {
            recentPhotosArray = NSMutableArray(object: self.photoData)
        }
        encodedData = NSKeyedArchiver.archivedDataWithRootObject(recentPhotosArray)
        userDefaults.setValue(encodedData, forKey: "recentlyViewedPhotos")
        userDefaults.synchronize()
        //dispatch_async(dispatch_get_main_queue(), { NSNotificationCenter.defaultCenter().postNotificationName("updateRecentlyViewedList", object: nil)})
    }
}
