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
    private var clManager: CLLocationManager!
    
    var selectedLocation: CLLocation?
    var currentLocation = Variable<CLLocation?>(nil)
    
    private override init() {
        super.init()
        clManager = CLLocationManager()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyBest
        //clManager.requestLocation()
        clManager.requestWhenInUseAuthorization()
        clManager.startUpdatingLocation()
        let enabled = CLLocationManager.locationServicesEnabled()
        print("Enabled: \(enabled)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let first = locations.first {
            currentLocation.value = first
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
