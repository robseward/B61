//
//  BusInfoProvider.swift
//  BusRider
//
//  Created by Robert Seward on 12/21/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class BusInfoProvider {
    let provider = MoyaProvider<MTAService>()
    
    func nearbyBusLines(lat: Float, lon: Float) -> PrimitiveSequence<SingleTrait, [String]> {
        let request = MTAService.stopsForLocation(lat: lat, lon: lon, latSpan: 0.005, lonSpan: 0.005)
        let observable = provider.rx.request(request)
            .map(to: StopList.self)
            .map { stopList -> [String] in
                var h = Set<String>()
                stopList.stops.forEach { h.update(with: $0.routes[0].shortName) }
                return Array(h)
            }
        return observable
    }
}
