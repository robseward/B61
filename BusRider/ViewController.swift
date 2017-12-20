//
//  ViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/15/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    let provider = MoyaProvider<MTAService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let request = MTAService.stopsForLocation(lat: 40.6881291027667, lon: -73.96751666498955, latSpan: 0.005, lonSpan: 0.005)
        

        provider.request(request, completion: { result in
            switch result {
                case .success(let response):
                print(response.data)
            default:
                break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

