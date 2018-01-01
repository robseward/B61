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
    
    var location: Variable<CLLocation>
    var routes: Variable<[RouteModel]>
    private var busInfoProvider = BusInfoProvider()
    private let disposeBag = DisposeBag()
    
    init() {
        self.location = Variable<CLLocation>(CLLocation(latitude: 0, longitude: 0))
        self.routes = Variable<[RouteModel]>([])
        _configure()
    }
    
    private func _configure() {
        self.location.asObservable().subscribe(onNext: { (location) in
            self._updateRoutes(location: location)
        }).disposed(by: disposeBag)
    }
    
    private func _updateRoutes(location: CLLocation) {
        self.busInfoProvider.nearbyBusLines(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            .subscribe(onSuccess: { (routes) in
                self.routes.value = routes
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
}
