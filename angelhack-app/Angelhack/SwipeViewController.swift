//
//  SwipeViewController.swift
//  Angelhack
//
//  Created by Alexander Juda on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class SwipeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var leftViewController: UIViewController!
    var rightViewController: UIViewController!
    
    override func viewDidLoad() {
        let rightFrame = rightContainerView.frame
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(rightFrame), CGRectGetMaxY(rightFrame))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "leftEmbedSegue" {
            leftViewController = segue.destinationViewController as! UIViewController
        } else if segue.identifier == "rightEmbedSegue" {
            rightViewController = segue.destinationViewController as! UIViewController
        }
    }
    
    // ------ scroll view delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < scrollView.bounds.width / 2 {
            // scrolled to left VC
            self.pageControl.currentPage = 0
        } else {
            self.pageControl.currentPage = 1
        }
        
        if let sendViewController = rightViewController as? SendViewController {
            sendViewController.textView.resignFirstResponder()
        }
    }
}