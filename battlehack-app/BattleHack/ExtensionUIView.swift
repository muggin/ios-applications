//
//  ExtensionUIView.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

extension UIView {
    static func defaultColor () -> UIColor {
        return UIColor(red:1, green:0.49, blue:0.2, alpha:1)
    }
    
    func setBorders() {
        self.setBordersColor(UIView.defaultColor())
    }
    
    func setBordersColor(color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.CGColor
    }
}