//
//  RouteButtonView.swift
//  BusRider
//
//  Created by Rob Seward on 1/4/18.
//  Copyright © 2018 Robert Seward. All rights reserved.
//

import UIKit

class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        return hitView == self ? nil : hitView
    }
}
