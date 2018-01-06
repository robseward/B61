//
//  MainMapViewModel.swift
//  BusRider
//
//  Created by Robert Seward on 12/29/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import MapKit

struct RoutePolyline {
    let routeId: String
    let polylines: [MKPolyline]
    let color: UIColor
}

class MainMapViewModel {
    typealias RouteID = String
    
    //Input
    var location: Variable<CLLocationCoordinate2D>
    
    //output
    var routes: Variable<[RouteModel]>
    var polylines = Variable<[RouteID : [MKPolyline]]>([:])
    var displayedPolylines = [RouteID : [MKPolyline]]()
    var colorMap = [MKPolyline : UIColor]()

    private var busInfoProvider = BusInfoProvider()
    private let disposeBag = DisposeBag()
    
    init() {
        self.location = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.routes = Variable<[RouteModel]>([])
        _configure()
    }
    
    private func _configure() {
        LocationManager.shared.selectedLocation.asObservable()
            .distinctUntilChanged({ (locationA, locationB) -> Bool in
                if let locationA = locationA, let locationB = locationB {
                    let radius: Double = 100
                    let d = abs(locationA.distance(from: locationB))
                    print("Distance: \(d)")
                    return d < radius
                } else if locationA == nil && locationB != nil || locationB == nil && locationA != nil {
                    return false
                } else {
                    return true
                }
            })
            .subscribe(onNext: { managerLocation in
                guard let managerLocation = managerLocation else { return }
                self.location.value = managerLocation
            }).disposed(by: disposeBag)
        
        self.location.asObservable().subscribe(onNext: { (location) in
            self._updateRoutes(location: location)
        }).disposed(by: disposeBag)
        
        routes.asObservable().subscribe(onNext: { routes in
            routes.forEach { route in
                self._getPolylines(routeId: route.routeId)
            }
        }).disposed(by: disposeBag)
    }
    
    private func _updateRoutes(location: CLLocationCoordinate2D) {
        self.busInfoProvider.nearbyBusLines(lat: location.latitude, lon: location.longitude)
            .subscribe(onSuccess: { (routes) in
                self.routes.value = routes
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
    
    private func _getPolylines(routeId: String) {
        busInfoProvider.polylinesForRoute(routeId: routeId)
            .subscribe(onSuccess: { stopGroupings in
                let mkPolylines = stopGroupings.polylines.map { line -> MKPolyline in
                    var line = line //needs to be a var to pass in as pointer
                    return MKPolyline(coordinates: &line, count: line.count)
                }
                let color = stopGroupings.route.color
                for line in mkPolylines {
                    self.colorMap[line] = color
                }
                self.polylines.value[routeId] = mkPolylines
                
            }, onError: { error in
                //print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
