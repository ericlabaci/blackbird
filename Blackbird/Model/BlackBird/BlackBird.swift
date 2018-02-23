//
//  Tweet.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation

class BlackBird {
    var text: String
    var time: Date
    var likes : Int
    var userId : String?
    
    init(text: String, time: Date, likes: Int) {
        self.text = text
        self.time = time
        self.likes = likes
    }
    
    init() {
        self.text = ""
        self.time = Date()
        self.likes = 0
    }
    
    convenience init(data: [String: Any], userId: String) {
        if let text = data[FirebaseKnots.Blackbirds.Text] as? String, let time = data[FirebaseKnots.Blackbirds.Timestamp] as? Date, let likes = data[FirebaseKnots.Blackbirds.Likes] as? Int {
            self.init(text: text, time: time, likes: likes)
            self.userId = userId
        } else {
            self.init()
        }
        
    }
}
