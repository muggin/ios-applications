//
//  BezierPathView.swift
//  Dropit
//
//  Created by Wojtek on 7/24/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit

class BezierPathView: UIView {
    var path: UIBezierPath! {
    didSet {
        self.setNeedsDisplay()
    }
    }
    
    override func drawRect(rect: CGRect) {
        if self.path {
        self.path.stroke()
        }
    }
}