//
//  MTAService.swift
//  BusRider
//
//  Created by Robert Seward on 12/18/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation
import Moya
import Alamofire


enum MTAService {
    case stopsForLocation(lat: Float, lon: Float, latSpan: Float, lonSpan: Float)
    case stopsForRoute(routeId: String)
}

extension MTAService: TargetType {
    var baseURL: URL {
        return URL(string: "https://bustime.mta.info/api/where/")!
    }
    
    var path: String {
        switch self {
        case .stopsForLocation(_, _, _, _): return "stops-for-location.json"
        case .stopsForRoute(let routeId): return "stops-for-route/\(routeId).json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .stopsForLocation(_, _, _, _), .stopsForRoute(_): return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .stopsForLocation(_,_,_,_):
            return dataForFileName(name: "stops-for-location", ext: "json")
        case .stopsForRoute(_):
            return dataForFileName(name: "stops-for-route", ext: "json")
        }
    }
    
    var task: Task {
        switch self {
        case .stopsForLocation(let lat, let lon, let latSpan, let lonSpan):
            return Task.requestParameters(parameters: ["lat" : lat, "lon" : lon, "latSpan" : latSpan, "lonSpan" : lonSpan, "key" : apiKey], encoding: URLEncoding.queryString)
        case .stopsForRoute(_) : return Task.requestParameters(parameters: ["key" : apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var apiKey: String {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: path),
            let apiKey = keys["mtaKey"] as? String
        {
            return apiKey
        } else {
            assert(false, "Key not set in keys plist")
            return ""
        }
    }
    
    func dataForFileName(name: String, ext: String) -> Data {
        let filePath = Bundle.main.path(forResource: name, ofType: ext)!
        do {
            return try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch let e {
            assert(false, e.localizedDescription)
            return Data()
        }
    }
}

extension MoyaProvider {
    
}
