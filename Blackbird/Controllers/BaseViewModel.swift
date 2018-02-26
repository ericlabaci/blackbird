//
//  BaseViewModel.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class BaseViewModel {
    deinit {
        ConsoleLogger.log("Deinit model: \(self)")
    }
    
    func stopAllListeners() {
        
    }
}
