//
//  RegistrationViewModel.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/26/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAuth

class RegistrationViewModel : BaseViewModel {
    var profileImage: UIImage?
    var email = ""
    var password = ""
    var name = ""
    var userName = ""
    
    //MARK: - Functions
    func register(success: (() -> ())?, failure: ((Error) -> ())?) {
        FirebaseUtils.register(email: self.email, password: self.password, name: self.name, userName: self.userName, profileImage: self.profileImage, success: { (user) in
            success?()
        }, failure: { (error) in
            failure?(error)
        })
    }
}
