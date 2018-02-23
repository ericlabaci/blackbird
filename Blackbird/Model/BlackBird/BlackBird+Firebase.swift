//
//  BlackBird+Parser.swift
//  Blackbird
//
//  Created by Raphael Carletti on 2/23/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import Foundation

extension BlackBird {
    func addBlackBirdOnFB(success: (() -> ())?, failure: ((Error)-> ())?){
        let data = [FirebaseKnots.Blackbirds.Text: self.text, FirebaseKnots.Blackbirds.Timestamp: self.time, FirebaseKnots.Blackbirds.Likes: self.likes] as [String: Any]
        FirebaseUtils.addBlackBird(data: data, success: success, failure: failure)
    }
    
}
