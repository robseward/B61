//
//  DirectionSelectionViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/26/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import QuartzCore

class DirectionSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var routeId: String?
    var disposeBag = DisposeBag()
    var viewModel = DirectionSelectionViewModel()
    
    @IBOutlet weak var directionButtonB: UIButton!
    @IBOutlet weak var directionButtonA: UIButton!
    @IBOutlet weak var routeSymbolView: UIView!
    @IBOutlet weak var routeSymbolLabel: UILabel!
    @IBOutlet weak var routeSymbolWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeSymbolView.layer.cornerRadius = routeSymbolWidthConstraint.constant / 2.0
        
        viewModel.route.asObservable()
            .map { (routeModel) -> String in
                return routeModel?.shortName ?? "-"
            }
            .bind(to: routeSymbolLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.route.asObservable()
            .subscribe(onNext: { (routeModel) in
                guard let routeModel = routeModel else { return }
                self.routeSymbolView.backgroundColor = routeModel.color
            })
            .disposed(by: disposeBag)
        
        viewModel.stopGroups.asObservable()
            .subscribe( onNext: { groups in
                guard groups.count >= 2 else { return }
                let groupA = groups[0]
                let groupB = groups[1]
                self.directionButtonA.setTitle(groupA.name, for: .normal)
                self.directionButtonB.setTitle(groupB.name, for: .normal)
            }).disposed(by: disposeBag)
            
    }
    
    func configureForRoute(routeId: String) {
        viewModel.routeId.value = routeId
    }
    
    func showStops(stopGroup: StopGroup) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "StopSelection") as? StopSelectionViewController {
            show(vc, sender: self)
            vc.setStopGroup(stopGroup: stopGroup)
        }

    }
}
