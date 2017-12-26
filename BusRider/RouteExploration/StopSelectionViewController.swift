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

    var routeId: String?
    var disposeBag = DisposeBag()
    var viewModel = StopSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let routeId = routeId else {
            assert(false)
            return
        }
        
    }
}
