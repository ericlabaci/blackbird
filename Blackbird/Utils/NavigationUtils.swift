//
//  NavigationUtils.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class NavigationUtils {
    static func goToHome() {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        if let navController = rootVC as? UINavigationController {
            let storyboard = UIStoryboard(name: Storyboard.TabBar, bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                //Need to hide Navigation Bar or the layout will bug in Home
                navController.setNavigationBarHidden(true, animated: false)
                navController.pushViewController(vc, animated: true)
                let controllers = navController.viewControllers
                if let homeController = controllers.last {
                    navController.viewControllers = [homeController]
                }
            }
        }
    }
}