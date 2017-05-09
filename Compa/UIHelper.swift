//
//  UIHelper.swift
//  Compa
//
//  Created by MacBook Pro on 5/9/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

public extension UIView {
    public func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        //mask.path = UIBezierPath(ovalInRect: CGRectMake(bounds.midX - width / 2, bounds.midY - width / 2, width, width)).cgPath
        mask.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: bounds.midX - width / 2, y: bounds.midY - width / 2), size: CGSize(width: width, height: width))).cgPath
        self.layer.mask = mask
    }
}
