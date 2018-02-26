//
//  BaseViewModel.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import FirebaseFirestore

class BaseViewModel {
    private var listeners: [ListenerRegistration] = []
    
    deinit {
        ConsoleLogger.log("Deinit model: \(self)")
    }
    
    func addListener(listener: ListenerRegistration) {
        self.listeners.append(listener)
    }
    
    func stopAllListeners() {
        for listener in self.listeners {
            listener.remove()
        }
    }
}
