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
}

extension MTAService: TargetType {
    var baseURL: URL {
        return URL(string: "https://bustime.mta.info/api/where/")!
    }
    
    var path: String {
        switch self {
        case .stopsForLocation(_, _, _, _): return "stops-for-location.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .stopsForLocation(_, _, _, _): return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .stopsForLocation(_,_,_,_):
            return """
            {
                "code": 200,
                "currentTime": 1513635655465,
                "data": {
                    "limitExceeded": false,
                    "stops": [
                        {
                            "code": "303021",
                            "direction": "E",
                            "id": "MTA_303021",
                            "lat": 40.687856,
                            "locationType": 0,
                            "lon": -73.968348,
                            "name": "LAFAYETTE AV/VANDERBILT AV",
                            "routes": [
                                {
                                    "agency": {
                                        "disclaimer": "",
                                        "id": "MTA NYCT",
                                        "lang": "en",
                                        "name": "MTA New York City Transit",
                                        "phone": "718-330-1234",
                                        "privateService": false,
                                        "timezone": "America/New_York",
                                        "url": "http://www.mta.info"
                                    },
                                    "color": "00AEEF",
                                    "description": "via DeKalb & Lafayette Av",
                                    "id": "MTA NYCT_B38",
                                    "longName": "Ridgewood - Downtown Brooklyn",
                                    "shortName": "B38",
                                    "textColor": "FFFFFF",
                                    "type": 3,
                                    "url": "http://web.mta.info/nyct/bus/schedule/bkln/b038cur.pdf"
                                }
                            ],
                            "wheelchairBoarding": "UNKNOWN"
                        }
                    ]
                }
            }
            """.data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .stopsForLocation(let lat, let lon, let latSpan, let lonSpan):
            return Task.requestParameters(parameters: ["lat" : lat, "lon" : lon, "latSpan" : latSpan, "lonSpan" : lonSpan, "key" : apiKey], encoding: URLEncoding.queryString)
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
}

extension MoyaProvider {
    
}
