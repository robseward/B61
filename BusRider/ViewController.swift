//
//  ViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/15/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let lat: Float = 40.6881291027667
        let lon: Float = -73.96751666498955
        
//        let provider = MoyaProvider<MTAService>()
//
//        let request = MTAService.stopsForLocation(lat: lat, lon: lon, latSpan: 0.005, lonSpan: 0.005)
//        provider.rx.request(request)
//            .map(to: StopList.self)
//            .map { stopList -> [String] in
//                var h = Set<String>()
//                stopList.stops.forEach { h.update(with: $0.routes[0].shortName) }
//                return Array(h)
//            }
//            .subscribe(onSuccess: { (strings) in
//                print(strings)
//            }) { (error) in
//                print(error.localizedDescription)
//            }.disposed(by: bag)
        
        let provider = BusInfoProvider()
        provider.nearbyBusLines(lat: lat, lon: lon)
            .subscribe(onSuccess: { (strings) in
                print(strings)
            }, onError: {error in
                print(error.localizedDescription)
            }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

