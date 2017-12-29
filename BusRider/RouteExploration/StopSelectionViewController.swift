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
        
        viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self))
            { (row, element, cell) in
                cell.textLabel?.text = "\(element.name)"
                if row == self.viewModel.closestStopIndex {
                    cell.contentView.backgroundColor = UIColor.gray
                } else {
                    cell.contentView.backgroundColor = UIColor.white
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.items.asObservable().subscribe(onNext: { stops in
            if let index = self.viewModel.closestStopIndex {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(StopModel.self)
            .subscribe(onNext: { stop in
                self.showStopPage(stop: stop)
            }).disposed(by: disposeBag)
    }
    
    func showStopPage(stop: StopModel) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            present(vc, animated: true, completion: nil)
            vc.showStopPage(stopCode: stop.code)
        }
    }
    
    func setStopGroup(stopGroup: StopGroup) {
        viewModel.items.value = stopGroup.stops
    }
}
