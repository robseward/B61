//
//  MainMapViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/29/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MainMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var viewModel = MainMapViewModel()
    var routeButtonsViewController: RouteButtonsViewController?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        _addTrackingButton()
        _configureMap()
        
        viewModel.routes.asObservable().subscribe(onNext: { (routes) in
            self.routeButtonsViewController?.removeButtons(animated: true, completion: {
                self.routeButtonsViewController?.createButtonsForRoutes(routes: routes)
                self.routeButtonsViewController?.displayButtons(animated: true)
            })
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        let lat: CLLocationDegrees = 40.6881291027667
        let lon: CLLocationDegrees = -73.96751666498955
        let location = CLLocation(latitude: lat, longitude: lon)
        
        viewModel.location.value = location
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteButtonsViewController {
            self.routeButtonsViewController = routeViewController
        }
    }
    
    private func _configureMap() {
        mapView.showsUserLocation = false
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
