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
        self.scrollView!.contentSize = self.image ? self.image!.size : CGSizeZero
    }
    }
    
    var imageURL: NSURL? {
    didSet {
        // Might block main queue if URL is online.
        //self.image = UIImage(data: NSData(contentsOfURL: self.imageURL))
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
        if (self.scrollView) {
            self.scrollView!.contentSize = self.image ? self.image!.size : CGSizeZero
        }
        self.activityIndicator?.stopAnimating()
    }
    }
    
    lazy var imageView: UIImageView! = UIImageView()
    
    
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
        if (self.imageURL) {
            var request = NSURLRequest(URL: self.imageURL)
            var configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            var session = NSURLSession(configuration: configuration)
            var task = session.downloadTaskWithRequest(request, completionHandler: {
                (localfile, response, error) in
                if (!error) {
                    if (request.URL.isEqual(self.imageURL)) {
                        var image = UIImage(data: NSData(contentsOfURL: localfile))
                        dispatch_async(dispatch_get_main_queue(), {self.image = image})
                    }
                }
            })
            task.resume()
        }
    }
}
