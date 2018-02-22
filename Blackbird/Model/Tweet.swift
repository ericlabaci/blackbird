//
//  Tweet.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation

class Tweet {
    var name: String
    var user: String
    var tweet: String
    
    init(name: String, user: String, tweet: String) {
        self.name = name
        self.tweet = tweet
        self.user = user
    }
}
