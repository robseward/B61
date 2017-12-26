//
//  ViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/15/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class BusLinesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = Variable<[RouteModel]>([])
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let lat: Float = 40.6881291027667
        let lon: Float = -73.96751666498955
        
        items.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, element, cell) in
            cell.textLabel?.text = "\(element.shortName)"
            }
            .disposed(by: disposeBag)

        
        let provider = BusInfoProvider()
        provider.nearbyBusLines(lat: lat, lon: lon)
            .subscribe(onSuccess: { (routes) in
                self.items.value = routes
            }, onError: {error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)

        tableView.rx
            .modelSelected(RouteModel.self)
            .subscribe(onNext: { (route) in
                self.showDirectionSelection(routeId: route.routeId)
            }).disposed(by: disposeBag)
//            .subscribe(onNext: { route in
//                //let route = items.value[indexPath]
//                self.showDirectionSelection(routeId: route.routeId)
//            })
//            .disposed(by: disposeBag)

    }

    func showDirectionSelection(routeId: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "DirectionSelection") as? DirectionSelectionViewController {
            vc.routeId = routeId
            show(vc, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

