//
//  MainMapViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/29/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        _configureMap()
        _addTrackingButton()
    }

    private func _configureMap() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    private func _addTrackingButton() {
        let button = MKUserTrackingButton(mapView: mapView)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10), button.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10)])
    }

}
