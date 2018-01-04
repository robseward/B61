//
//  LocationManager.swift
//  BusRider
//
//  Created by Robert Seward on 12/27/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class LocationManager: NSObject, CLLocationManagerDelegate {
    static var shared = LocationManager()

    var selectedLocation = Variable<CLLocation?>(nil)
}
