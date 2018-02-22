//
//  BaseViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    //MARK: - Variables
    internal let disposeBag = DisposeBag()
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ConsoleLogger.log("Current controller: \(self)")
    }
    
    deinit {
        ConsoleLogger.log("Deinit controller: \(self)")
    }
}
