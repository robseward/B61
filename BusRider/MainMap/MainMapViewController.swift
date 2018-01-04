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
import RxCocoa
import Action

class MainMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var viewModel = MainMapViewModel()
    var routeButtonsViewController: RouteButtonsViewController?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        mapView.delegate = self
        _addTrackingButton()
        _configureMap()
        _setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
//        let lat: CLLocationDegrees = 40.6881291027667
//        let lon: CLLocationDegrees = -73.96751666498955
//        let location = CLLocation(latitude: lat, longitude: lon)
//        
//        viewModel.location.value = location
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteButtonsViewController {
            self.routeButtonsViewController = routeViewController
        }
    }
    
    private func _setupBindings() {

        
        viewModel.routes.asObservable().subscribe(onNext: { (routes) in
            self.routeButtonsViewController?.removeButtons(animated: true, completion: {
                guard let routeButtonsViewController = self.routeButtonsViewController else { return }
                let buttons = routeButtonsViewController.createButtonsForRoutes(routes: routes)
                for i in 0..<buttons.count {
                    let button = buttons[i]
                    button.addTarget(self, action: #selector(self.routeButtonPressed(sender:)), for: .touchUpInside)
                }
                
                self.routeButtonsViewController?.displayButtons(animated: true)
            })
        }).disposed(by: disposeBag)
    }
    
    @objc func routeButtonPressed(sender: UIButton) {
        if let route = routeButtonsViewController?.buttonInfo[sender]?.route {
            self._showDirectionSelection(routeId: route.routeId)
        }
    }
    
    private func _showDirectionSelection(routeId: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "DirectionSelection") as? DirectionSelectionViewController {
            vc.routeId = routeId
            show(vc, sender: self)
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
    
    //MARK: MapView delegate methods
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("User location update")
        LocationManager.shared.selectedLocation.value = userLocation.location?.coordinate
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region did change: \(mapView.centerCoordinate)")
        LocationManager.shared.selectedLocation.value = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print("Mapview mode change: \(mode)")
    }

}
