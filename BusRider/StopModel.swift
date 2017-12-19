//
//  StopModel.swift
//  BusRider
//
//  Created by Robert Seward on 12/18/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import Foundation

protocol Model {
    init(json: Data)
}

class StopModel : Model {

    
    required init(json: Data) {
        
    }
}
