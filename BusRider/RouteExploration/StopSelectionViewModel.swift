//
//  StopSelectionViewModel.swift
//  BusRider
//
//  Created by Robert Seward on 12/26/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class StopSelectionViewModel {
    var items = Variable<[StopModel]>([])
    var lat: Float?
    var lon: Float?
    var routeName: String?
    var closestStopIndex: Int?
    var disposeBag = DisposeBag()

    init() {
        items.asObservable().subscribe(onNext: { (stops) in
            guard let location = LocationManager.shared.selectedLocation.value else { return }
            self.closestStopIndex = self.findClosestStopIndex(stops: stops, target: location)
        }).disposed(by: disposeBag)
    }
    
    func findClosestStopIndex(stops: [StopModel], target: CLLocation) -> Int? {
        var min: Double = Double.greatestFiniteMagnitude
        var result: Int?
        
        stops.enumerated().forEach ( { index, element in
            let distance = target.distance(from: element.location)
            if  distance < min {
                min = distance
                result = index
            }
        })
        
        return result
    }
    
}
