//
//  WebViewController.swift
//  BusRider
//
//  Created by Robert Seward on 12/29/17.
//  Copyright © 2017 Robert Seward. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showStopPage(stopCode: String) {
        let baseUrl = "https://bustime.mta.info/m/index?q="
        let urlString = ("\(baseUrl)\(stopCode)")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
