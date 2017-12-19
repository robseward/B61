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


class StopModel : ALSwiftyJSONAble {
    let code: String
    let name: String
    let routes: [RouteModel]
    
    required init?(jsonData: JSON) {
        if
            let code = jsonData["code"].string,
            let name = jsonData["name"].string
        {
            self.code = code
            self.name = name
            self.routes = RouteModel.routeCollection(jsonData: jsonData["routes"])
        } else {
            return nil
        }
    }
}

class RouteModel : ALSwiftyJSONAble {
    let longName: String
    let shortName: String
    
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
            let shortName = jsonData["shortName"].string
        {
            self.longName = longName
            self.shortName = shortName
        } else {
            return nil
        }
    }
}
