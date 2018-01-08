//
//  DirectionSelectionViewModel.swift
//  BusRider
//
//  Created by Robert Seward on 12/26/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DirectionSelectionViewModel {
    //input
    var routeId = Variable<String?>(nil)
    
    //output
    var stopGroups = Variable<[StopGroup]>([])
    var route = Variable<RouteModel?>(nil)

    private var disposeBag = DisposeBag()
    private let provider = BusInfoProvider()
    
    init() {
        routeId.asObservable()
            .subscribe(onNext: { routeId in
                guard let routeId = routeId else { return }
                self._loadStopGroupsForRoute(routeId: routeId)
            }).disposed(by: disposeBag)
    }
    
    private func _loadStopGroupsForRoute(routeId: String) {
        provider.directionsForRoute(routeId: routeId)
            .subscribe(onSuccess: { (stopGroupings) in
                self.stopGroups.value = stopGroupings.groupings
                self.route.value = stopGroupings.route
            }) { (error) in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
}
