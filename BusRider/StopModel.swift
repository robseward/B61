//
//  StopModel.swift
//  BusRider
//
//  Created by Robert Seward on 12/18/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import CoreLocation

class StopList : ALSwiftyJSONAble {
    let stops: [StopModel]
    
    required init?(jsonData: JSON) {
        var stops = [StopModel]()
        let stopArray = jsonData["data"]["stops"]
        for (_,subJson):(String, JSON) in stopArray {
            if let stop = StopModel(jsonData: subJson) {
                stops.append(stop)
            }
        }
        self.stops = stops
    }
}

class StopGroupings : ALSwiftyJSONAble {
    let groupings: [StopGroup]
    required init?(jsonData: JSON) {
        var groupings = [StopGroup]()
        let groups = jsonData["data"]["stopGroupings"]
        for (_,subJson):(String, JSON) in groups {
            for (_,subJson):(String, JSON) in subJson["stopGroups"] {
                if let group = StopGroup(jsonData: subJson) {
                    groupings.append(group)
                }
            }
        }
        
        var stops = [String : StopModel]()
        let stopArray = jsonData["data"]["stops"]
        for (_,subJson):(String, JSON) in stopArray {
            if let stop = StopModel(jsonData: subJson) {
                stops[stop.stopId] = stop
            }
        }
        
        groupings.forEach { (stopGroup) in
            stopGroup.stops = stopGroup.stopIds.flatMap { stops[$0] }
        }
        self.groupings = groupings
    }
}
        
class StopGroup: ALSwiftyJSONAble {
    let name: String
    let stopIds: [String]
    var stops = [StopModel]()

    required init?(jsonData: JSON) {
        if
            let name = jsonData["name"]["name"].string,
            let stopIds = jsonData["stopIds"].array
        {
            self.name = name
            self.stopIds = stopIds.flatMap { $0.string }
        } else {
            return nil
        }
    }
}

class StopModel : ALSwiftyJSONAble {
    let code: String
    let name: String
    let stopId: String
    let routes: [RouteModel]
    let location: CLLocationCoordinate2D
    
    required init?(jsonData: JSON) {
        if
            let code = jsonData["code"].string,
            let name = jsonData["name"].string,
            let stopId = jsonData["id"].string,
            let lat = jsonData["lat"].double,
            let lon = jsonData["lon"].double
        {
            self.code = code
            self.name = name
            self.stopId = stopId
            self.routes = RouteModel.routeCollection(jsonData: jsonData["routes"])
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            return nil
        }
    }
}

class RouteModel : ALSwiftyJSONAble {
    let longName: String
    let shortName: String
    let routeId: String
    let hexColor: String
    var color: UIColor {
        return _hexStringToUIColor(hex: hexColor)
    }
    
    static func routeCollection(jsonData: JSON) -> [RouteModel] {
        var routes = [RouteModel]()
        for (_,subJson):(String, JSON) in jsonData {
            if let route = RouteModel(jsonData: subJson) {
                routes.append(route)
            }
        }
        return routes
    }
    
    required init?(jsonData: JSON) {
        if
            let longName = jsonData["longName"].string,
            let shortName = jsonData["shortName"].string,
            let id = jsonData["id"].string,
            let color = jsonData["color"].string
        {
            self.longName = longName
            self.shortName = shortName
            self.routeId = id
            self.hexColor = color
        } else {
            return nil
        }
    }
    
    private func _hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    class var stub: RouteModel {
        let json = JSON(parseJSON: """
                                    {
                                        "longName": "Test Route to Brooklyn",
                                        "shortName": "B69",
                                        "id": "foo",
                                        "color": "FF0000"
                                    }
                                    """)
        return RouteModel(jsonData: json)!
    }
}
