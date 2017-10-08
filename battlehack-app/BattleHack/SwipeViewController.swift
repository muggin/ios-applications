//
//  ViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import UIKit
import CoreData

class SwipeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: DMPageControl!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControl.numberOfPages = 3;
        self.pageControl.currentPage = 1;
        self.pageControl.defersCurrentPageDisplay = true;
        self.pageControl.dotStyle = UInt(DMPageControlDotStyle_OnFull_OffFull)
        self.pageControl.backgroundColor = UIColor.clearColor()
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width * 3, self.scrollView.bounds.height)
        
        
        let sellVC = self.storyboard?.instantiateViewControllerWithIdentifier("sellVC") as? UIViewController
        let centerVC = self.storyboard?.instantiateViewControllerWithIdentifier("centerVC") as? UIViewController
        let buyNavigationVC = self.storyboard?.instantiateViewControllerWithIdentifier("buyVC") as? UINavigationController
        
        let buyVC = buyNavigationVC?.childViewControllers.first as! BuyViewController
        buyVC.backendConnector = BackendConnector(serverAddress: "http://10.205.251.112:9000")
        buyVC.backendConnector.delegate = buyVC
        
        
        let screenWidth = self.scrollView.bounds.width
        
        sellVC!.view.frame.origin.x = 0
        centerVC!.view.frame.origin.x = screenWidth
        buyNavigationVC!.view.frame.origin.x = screenWidth * 2
        
        self.addChildViewController(sellVC!)
        self.addChildViewController(centerVC!)
        self.addChildViewController(buyNavigationVC!)
        
        self.scrollView.addSubview(sellVC!.view)
        self.scrollView.addSubview(centerVC!.view)
        self.scrollView.addSubview(buyNavigationVC!.view)
        
        self.scrollView.contentSize = CGSizeMake(screenWidth * 3, self.scrollView.bounds.height)
        self.scrollView.contentOffset = CGPointMake(screenWidth, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let screenWidth = self.scrollView.bounds.size.width
        let fractionalPage = self.scrollView.contentOffset.x / screenWidth
        let nearestNumber = Int(round(fractionalPage))
        
        if self.pageControl.currentPage != nearestNumber {
            pageControl.currentPage = nearestNumber
            
            if (self.scrollView.dragging) {
                pageControl.updateCurrentPageDisplay()
            }
        }
    }
    
}

