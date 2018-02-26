//
//  NewTweetViewModel.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/23/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation

class NewTweetViewModel {
    var text: String? {
        didSet {
            if let text = self.text {
                self.blackBird.text = text
            }
        }
    }
    var time: Date? {
        didSet {
            if let time = self.time {
                self.blackBird.time = time
            }
        }
    }
    var likes : Int? {
        didSet {
            if let likes = self.likes {
                self.blackBird.likes = likes
            }
        }
    }
    var blackBird : BlackBird = BlackBird()
    
    init() {
        
    }
    
    func addTweetToFirebase(success: (() -> ())?, failure: ((Error)-> ())?){
        self.blackBird.addBlackBirdOnFB(success: success, failure: failure)
    }
    
    
}
