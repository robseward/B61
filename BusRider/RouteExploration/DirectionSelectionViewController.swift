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

class DirectionSelectionViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var routeId: String?
    var disposeBag = DisposeBag()
    var viewModel = DirectionSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let routeId = routeId else {
            assert(false)
            return
        }
        
        viewModel.items.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, element, cell) in
                cell.textLabel?.text = "\(element.name)"
            }
            .disposed(by: disposeBag)

        
        viewModel.loadStopGroupsForRoute(routeId: routeId)
        
        
    }
    
}
