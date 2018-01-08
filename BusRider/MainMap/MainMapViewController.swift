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
    @IBOutlet weak var routeExploreContainerView: UIView!
    var directionSelectionViewController: DirectionSelectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        _addTrackingButton()
        _configureMap()
        _setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteButtonsViewController {
            self.routeButtonsViewController = routeViewController
        } else if let directionSelectionViewController = segue.destination as? DirectionSelectionViewController {
            self.directionSelectionViewController = directionSelectionViewController
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
        
        viewModel.polylinesToDisplay.asObservable()
            .subscribe(onNext: { polylines in
                for (_, routeLines) in polylines {
                    routeLines.forEach(self.mapView.add)
                }
            }).disposed(by: disposeBag)
    
        viewModel.polylinesToRemove.asObservable()
            .subscribe(onNext: {polylines in
                for (_, routeLines) in polylines {
                    routeLines.forEach(self.mapView.remove)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func routeButtonPressed(sender: UIButton) {
        if let route = routeButtonsViewController?.buttonInfo[sender]?.route {
            //self._showDirectionSelection(routeId: route.routeId)
            directionSelectionViewController?.configureForRoute(routeId: route.routeId)
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
        if
            let polyline = overlay as? MKPolyline,
            let color = viewModel.colorMap[polyline]
        {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = color
            renderer.lineWidth = 2.0
            return renderer
        }
        fatalError("Something wrong...")
        //return MKOverlayRenderer()
    }

}
