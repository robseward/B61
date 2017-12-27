//
//  StopSelectionViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/26/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StopSelectionViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var disposeBag = DisposeBag()
    var viewModel = StopSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element.name)"
            }
            .disposed(by: disposeBag)
    }
    
    func setStopGroup(stopGroup: StopGroup) {
        viewModel.items.value = stopGroup.stops
    }
}
