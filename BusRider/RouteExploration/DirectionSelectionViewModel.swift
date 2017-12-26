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
    var items = Variable<[StopGroup]>([])
    var disposeBag = DisposeBag()
    
    func loadStopGroupsForRoute(routeId: String) {
        let provider = BusInfoProvider()
        
        provider.directionsForRoute(routeId: routeId)
            .subscribe(onSuccess: { (groups) in
                self.items.value = groups
            }) { (error) in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
}
