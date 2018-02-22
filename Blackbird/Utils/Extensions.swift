//
//  Extensions.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

extension String {
    var isValidName : Bool {
        return self.count > 0
    }
    
    var isValidUserName : Bool {
        return self.count > 4
    }
    
    var isValidEmail : Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        return self.count >= 8
    }
    
    func remainingChar() -> Int {
        return AppConfig.MaxCharTweet - self.count
    }
    
    var maxCharText : String {
        let maxIndex = self.index(self.startIndex, offsetBy: AppConfig.MaxCharTweet)
        return String(self[..<maxIndex])
    }
}

extension Int {
    var description : String {
        return String(self)
    }
}
