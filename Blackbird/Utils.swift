//
//  Utils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation

class ConsoleLogger {
    static func log(_ string: String?) {
        #if DEBUG
        print(string ?? "")
        #endif
    }
}
