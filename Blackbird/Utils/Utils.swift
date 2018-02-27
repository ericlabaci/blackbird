//
//  Utils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import AVKit

class ConsoleLogger {
    static func log(_ string: String?) {
        #if DEBUG
        print(string ?? "")
        #endif
    }
}

class UUIDUtils {
    static func uuidBasedOnTime() -> String {
        let uuidSize = MemoryLayout<uuid_t>.size
        let uuidPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: uuidSize)
        uuid_generate_time(uuidPointer)
        let uidVar = NSUUID(uuidBytes: uuidPointer).uuidString
        return uidVar
    }
}
