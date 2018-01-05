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
        
        viewModel.polylines.asObservable()
            .subscribe(onNext: { polylines in
                self._addPolylines(polylines: polylines)
            }).disposed(by: disposeBag)
    }
    
    @objc func routeButtonPressed(sender: UIButton) {
        if let route = routeButtonsViewController?.buttonInfo[sender]?.route {
            self._showDirectionSelection(routeId: route.routeId)
        }
    }
    
    private func _addPolylines(polylines: [String : [MKPolyline]]) {
        for (_, polylines) in polylines {
            for line in polylines {
                mapView.add(line)
            }
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
        switch mapView.userTrackingMode {
        case .follow, .followWithHeading:
            LocationManager.shared.selectedLocation.value = userLocation.location?.coordinate
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region did change: \(mapView.centerCoordinate)")
        LocationManager.shared.selectedLocation.value = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print("Mapview mode change: \(mode)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Return an `MKPolylineRenderer` for the `MKPolyline` in the `MKMapViewDelegate`s method
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .blue
            testlineRenderer.lineWidth = 2.0
            return testlineRenderer
        }
        fatalError("Something wrong...")
        //return MKOverlayRenderer()
    }

}
