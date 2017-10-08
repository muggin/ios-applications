//
//  CenterViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class CenterViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = NSTimer(timeInterval: 3, target: self, selector: "changeImage", userInfo: nil, repeats: true)
    }
    
//    func changeImage
}
