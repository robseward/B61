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
    
    var buttonAStopGroup = Variable<StopGroup?>(nil)
    var buttonBStopGroup = Variable<StopGroup?>(nil)
    var buttonATitle = Variable<String>("-")
    var buttonBTitle = Variable<String>("-")

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
                guard stopGroupings.groupings.count >= 2 else { return }
                
                self.buttonAStopGroup.value = stopGroupings.groupings[0]
                self.buttonBStopGroup.value = stopGroupings.groupings[1]
                
                self.buttonATitle.value = stopGroupings.groupings[0].name
                self.buttonBTitle.value = stopGroupings.groupings[1].name
                
            }) { (error) in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
}
