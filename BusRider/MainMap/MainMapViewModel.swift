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

class MainMapViewModel {
    
    //Input
    var location: Variable<CLLocationCoordinate2D>
    
    //output
    var routes: Variable<[RouteModel]>

    private var busInfoProvider = BusInfoProvider()
    private let disposeBag = DisposeBag()
    
    init() {
        self.location = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.routes = Variable<[RouteModel]>([])
        _configure()
    }
    
    private func _configure() {
        LocationManager.shared.selectedLocation.asObservable()
            .subscribe(onNext: { managerLocation in
                guard let managerLocation = managerLocation else { return }
                self.location.value = managerLocation
            }).disposed(by: disposeBag)
        
        self.location.asObservable().subscribe(onNext: { (location) in
            self._updateRoutes(location: location)
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
}
