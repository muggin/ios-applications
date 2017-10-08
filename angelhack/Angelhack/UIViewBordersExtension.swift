//
//  UIViewBordersExtension.swift
//  Angelhack
//
//  Created by Alexander Juda on 24/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

extension UIView {
    var bordersWidth:Float {
        get {
            return Float(self.layer.borderWidth)
        }
        set {
            layer.borderWidth = CGFloat(newValue)
            layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
}
