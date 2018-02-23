//
//  Constants.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit

class Color {
    static let secondaryColor = UIColor(red: 139/255, green: 219/255, blue: 231/255, alpha: 1.0)
}

class Storyboard {
    static let Authentication = "Authentication"
    static let TabBar = "TabBar"
    static let Home = "Home"
}

class ViewControllers {
    //MARK: Authentication
    static let Login = "LoginViewController"
    static let Registration = "RegistrationViewController"
    
    //MARK: Home
    static let NewTweet = "NewTweetViewController"
}

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
}

class Images {
    //MARK: Profile
    static let ProfileDefault = "default_profile_bird"
}

class Identifiers {
    static let tweetCell = "tweetCell"
}

class AppConfig {
    static var MaxCharTweet = 280
}
