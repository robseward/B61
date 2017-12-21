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
            if let group = StopGroup(jsonData: subJson) {
                groupings.append(group)
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
    
    required init?(jsonData: JSON) {
        if
            let code = jsonData["code"].string,
            let name = jsonData["name"].string,
            let stopId = jsonData["id"].string
        {
            self.code = code
            self.name = name
            self.stopId = stopId
            self.routes = RouteModel.routeCollection(jsonData: jsonData["routes"])
        } else {
            return nil
        }
    }
}

class RouteModel : ALSwiftyJSONAble {
    let longName: String
    let shortName: String
    let id: String
    
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
            let id = jsonData["id"].string
        {
            self.longName = longName
            self.shortName = shortName
            self.id = id
        } else {
            return nil
        }
    }
}
