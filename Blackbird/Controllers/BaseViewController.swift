//
//  BaseViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ConsoleLogger.log("Current controller: \(self)")
    }
    
    deinit {
        ConsoleLogger.log("Deinit controller: \(self)")
    }
}
