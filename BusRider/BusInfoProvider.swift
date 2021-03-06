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
import CoreLocation

class BusInfoProvider {
//    var provider = MoyaProvider<MTAService>(stubClosure: MoyaProvider.immediatelyStub)
    var provider = MoyaProvider<MTAService>()
    
    func nearbyBusLines(lat: CLLocationDegrees, lon: CLLocationDegrees) -> PrimitiveSequence<SingleTrait, [RouteModel]> {
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
    
    func directionsForRoute(routeId: String) -> PrimitiveSequence<SingleTrait, [StopGroup]>{
        let request = MTAService.stopsForRoute(routeId: routeId)
        let observable = provider.rx.request(request)
            .map(to: StopGroupings.self)
            .map { groupingList -> [StopGroup] in
                return groupingList.groupings
            }
        
        return observable
    }
    
    func polylinesForRoute(routeId: String) -> PrimitiveSequence<SingleTrait, StopGroupings> {
        let request = MTAService.stopsForRoute(routeId: routeId)
        let observable = provider.rx.request(request)
            .map(to: StopGroupings.self)
        return observable
    }
    
}
