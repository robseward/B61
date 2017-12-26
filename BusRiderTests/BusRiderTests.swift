//
//  BusRiderTests.swift
//  BusRiderTests
//
//  Created by Robert Seward on 12/15/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import Moya_SwiftyJSONMapper
@testable import BusRider

class BusRiderTests: XCTestCase {
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_busInfoStopGroups() {
        let busInfo = BusInfoProvider()
        busInfo.provider = MoyaProvider<MTAService>(stubClosure: MoyaProvider.immediatelyStub)
        
        busInfo.directionsForRoute(routeId: "Foo")
            .subscribe(onSuccess: { (stopGroups) in
                XCTAssert(stopGroups.count == 2)
            }, onError: { (error) in
                XCTFail()
            }).disposed(by: disposeBag)
    }
    
    func test_stopsEndpointReturnsStopList() {
        let provider = MoyaProvider<MTAService>(stubClosure: MoyaProvider.immediatelyStub)

        let request = MTAService.stopsForLocation(lat: 40.6881291027667, lon: -73.96751666498955, latSpan: 0.005, lonSpan: 0.005)

        let disposeBag = DisposeBag()
        provider.rx.request(request)
            .map(to: StopList.self)
            .subscribe(onSuccess: { (stopList) -> Void in
                XCTAssert(stopList.stops.count > 0)
            }, onError: { (error) -> Void in
                print(error)
                XCTFail()
            }).disposed(by: disposeBag)
    }
    
    func test_stopsForRoute_returnsStopGroups() {
        let provider = MoyaProvider<MTAService>(stubClosure: MoyaProvider.immediatelyStub)
        
        let request = MTAService.stopsForRoute(routeId: "MTA NYCT_B69")
        
        let disposeBag = DisposeBag()
        provider.rx.request(request)
            .map(to: StopGroupings.self)
            .subscribe(onSuccess: { (stopGroupings) in
                XCTAssert(stopGroupings.groupings.count == 2)
            }, onError: { (error) -> Void in
                print(error)
                XCTFail()
            }).disposed(by: disposeBag)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
