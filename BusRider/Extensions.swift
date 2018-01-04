//
//  Extensions.swift
//  BusRider
//
//  Created by Rob Seward on 1/4/18.
//  Copyright © 2018 Robert Seward. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

func == (l: CLLocationCoordinate2D, r: CLLocationCoordinate2D) -> Bool {
    return l.latitude == r.latitude && l.longitude == r.longitude
}
