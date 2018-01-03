//
//  RouteButtonsViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/31/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ButtonInfo {
    let route: RouteModel
    let positioningConstraints: (NSLayoutConstraint, NSLayoutConstraint)
}

class RouteButtonsViewController: UIViewController {

    var buttons = [UIButton]()
    var buttonInfo = [UIButton : ButtonInfo]()
    var locationView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        _setupLocationView()
    }

    private func _setupLocationView() {
        locationView = UIView()
        self.view.addSubview(locationView)
        locationView.translatesAutoresizingMaskIntoConstraints = false
        locationView.backgroundColor = UIColor.yellow
        let width: CGFloat = 15
        NSLayoutConstraint.activate(
        [locationView.widthAnchor.constraint(equalToConstant: width),
        locationView.heightAnchor.constraint(equalToConstant: width),
        locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        locationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        locationView.layer.cornerRadius = width/2.0
    }
    
    func removeButtons(animated: Bool, completion: @escaping ()->() ) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.buttons.forEach({
                $0.alpha = 0
            })
        }, completion: { _ in
            self.buttons.forEach({ $0.removeFromSuperview() })
            completion()
        })
    }
    
    func createButtonsForRoutes(routes: [RouteModel]) -> [UIButton] {
        buttons = routes.map { route -> UIButton in
            let size = CGSize(width: 50, height: 50)
            return _createButton(title: route.shortName, color: route.color, size: size)
        }
        
        for i in 0..<buttons.count {
            let button = buttons[i]
            let route = routes[i]
            let constraints = self._addButtonToCenterOfView(button: button)
            let info = ButtonInfo(route: route, positioningConstraints: constraints)
            buttonInfo[button] = info
            button.alpha = 0
        }
        
        return buttons
    }
    
    func displayButtons(animated: Bool) {
        // calculate positions around circle
        let locations = buttons.enumerated().map({ index, button -> (UIButton, CGPoint) in
            var offset = CGPoint.zero
            
            let radius: Double = 65
            let angle = (Double.pi / 3.0) * Double(index - 1)
            offset.y = CGFloat(sin(angle) * radius)
            offset.x = CGFloat(cos(angle) * radius)
            
            return (button, offset)
        })
        
        // Animate buttons
        locations.forEach({ (button, offset) in
            print(offset)
            let constraints = buttonInfo[button]!.positioningConstraints
            
            let duration = animated ? 0.3 : 0
            UIView.animate(withDuration: duration, animations: {
                constraints.0.constant = offset.x
                constraints.1.constant = offset.y
                button.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: { _ in

            })
        })
    }
    
    private func _createButton(title: String,
                              color: UIColor,
                              size: CGSize) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: size.width), button.heightAnchor.constraint(equalToConstant: size.height)])
        button.layer.cornerRadius = size.width / 2.0
        return button
    }
    
    /// Returns positioning constraints
    private func _addButtonToCenterOfView(button: UIButton) -> (NSLayoutConstraint, NSLayoutConstraint) {
        view.addSubview(button)
        let constraints = [button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20), button.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
        return (constraints[0], constraints[1])
    }
}
