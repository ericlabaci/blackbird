//
//  AlertControllerUtils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/23/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class AlertControllerUtils {
    class func getOKAlertController(code: AlertControllerCode, okCompletion: (() -> ())?) -> UIAlertController {
        let alertController = self.getBaseAlertController(code: code)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            okCompletion?()
        })
        alertController.addAction(okAction)
        
        return alertController
    }
    
    class func getYesNoAlertController(code: AlertControllerCode, yesCompletion: (() -> ())?, noCompletion: (() -> ())?) -> UIAlertController {
        let alertController = self.getBaseAlertController(code: code)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            yesCompletion?()
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
            noCompletion?()
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        return alertController
    }
    
    class func getSettingsAlertController(code: AlertControllerCode) -> UIAlertController {
        let alertController = self.getBaseAlertController(code: code)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(noAction)
        
        return alertController
    }
    
    private class func getBaseAlertController(code: AlertControllerCode) -> UIAlertController {
        if let path = Bundle.main.path(forResource: "AlertMessages", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path), let alertDict = dict["\(code.rawValue)"] as? NSDictionary {
            let title = alertDict["title"] as? String
            let message = alertDict["message"] as? String
            return UIAlertController(title: title, message: message, preferredStyle: .alert)
        } else {
            return self.getDefaultAlertController()
        }
    }
    
    private class func getButtonStyle(string: String?) -> UIAlertActionStyle {
        guard let string = string  else {
            return .default
        }
        if string == "default" {
            return .default
        } else if string == "cancel" {
            return .cancel
        } else if string == "destructive" {
            return .destructive
        }
        
        return .default
    }
    
    private class func getDefaultAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
}
