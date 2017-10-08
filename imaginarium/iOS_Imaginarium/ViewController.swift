//
//  ViewController.swift
//  iOS_Imaginarium
//
//  Created by Wojtek on 7/30/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.destinationViewController.isKindOfClass(ImageViewController)) {
            var imageVC: ImageViewController = segue.destinationViewController as ImageViewController
            imageVC.imageURL = NSURL(string: "https://www.apple.com/v/iphone-5s/gallery/b/images/download/\(segue.identifier).jpg")
            imageVC.title = segue.identifier
        
        }
    }


}

