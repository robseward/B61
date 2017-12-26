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
    
    func nearbyBusLines(lat: Float, lon: Float) -> PrimitiveSequence<SingleTrait, [RouteModel]> {
        let request = MTAService.stopsForLocation(lat: lat, lon: lon, latSpan: 0.005, lonSpan: 0.005)
        let observable = provider.rx.request(request)
            .map(to: StopList.self)
            .map { stopList -> [RouteModel] in
                var h = [String : RouteModel]()
                stopList.stops.forEach {
                    let route = $0.routes[0]
                    h[route.shortName] = route
                }
                return Array(h.values)
            }
        return observable
    }
    
    
}
