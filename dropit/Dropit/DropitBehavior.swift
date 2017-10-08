//
//  DropitBehavior.swift
//  Dropit
//
//  Created by Wojtek on 7/24/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class DropitBehavior: UIDynamicBehavior {
    //MARK: Properties
    lazy var collider: UICollisionBehavior = {
        var collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    lazy var gravity: UIGravityBehavior = {
        var gravity = UIGravityBehavior()
        gravity.magnitude = 1.0
        return gravity
    }()
    lazy var animationOptions: UIDynamicItemBehavior = {
        var animationOptions = UIDynamicItemBehavior()
        animationOptions.allowsRotation = false
        return animationOptions
    }()
    

    //MARK: Initializers
    init() {
        super.init()
        self.addChildBehavior(self.gravity)
        self.addChildBehavior(self.collider)
        self.addChildBehavior(self.animationOptions)

    }
    
    func addItem(item: UIDynamicItem) {
        self.gravity.addItem(item)
        self.collider.addItem(item)
        self.animationOptions.addItem(item)
        
    }
    
    func removeItem(item: UIDynamicItem) {
        self.gravity.removeItem(item)
        self.collider.removeItem(item)
        self.animationOptions.removeItem(item)
    }
}