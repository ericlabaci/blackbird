//
//  Constants.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

//MARL: - Colors
class Color {
    static let secondaryColor = UIColor(red: 139/255, green: 219/255, blue: 231/255, alpha: 1.0)
}

//MARK: - Storyboard
class Storyboard {
    static let Authentication = "Authentication"
    static let TabBar = "TabBar"
    static let Home = "Home"
}

//MARK: - ViewControllers
class ViewControllers {
    //MARK: Authentication
    static let Login = "LoginViewController"
    static let Registration = "RegistrationViewController"
    
    //MARK: Home
    static let NewTweet = "NewTweetViewController"
}

//MARK: - FirebaseKnots
struct FirebaseKnots {
    struct Users {
        static let Root = "users"
        static let Name = "name"
        static let UserName = "userName"
        static let Following = "following"
        static let Followers = "followers"
    }
    
    struct Blackbirds {
        static let Root = "blackbirds"
        static let Text = "text"
        static let Timestamp = "timestamp"
        static let Likes = "likes"
    }
    
    struct UserNames {
        static let Root = "userNames"
        struct UserNames {
            static let Root = "userNames"
            static let UserNames = "userNames"
        }
    }
}

//MARK: - Images
class Images {
    //MARK: Profile
    static let ProfileDefault = "default_profile_bird"
}

//MARK: - Identifiers
class Identifiers {
    static let blackBirdCell = "blackBirdCell"
}

//MARK: - AppConfig
class AppConfig {
    static var MaxCharTweet = 280
}

//MARK: - AlertController code
enum AlertControllerCode : UInt {
    case SomethingWentWrong = 0
    case RegisterFailed = 1
    case LoginFailed = 2
}
