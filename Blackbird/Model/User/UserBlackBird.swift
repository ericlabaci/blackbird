//
//  User.swift
//  Blackbird
//
//  Created by Uniseb on 24/02/2018.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class UserBlackBird {
    var userName : String
    var name : String
    var profileImage: UIImage?
    
    init(name: String, userName: String, profileImage: UIImage? = nil) {
        self.name = name
        self.userName = userName
        self.profileImage = profileImage
    }
}
